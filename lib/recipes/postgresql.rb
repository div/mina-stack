namespace :postgresql do

  require 'highline/import'

  desc "Install the latest stable release of PostgreSQL."
  task :install do
    invoke :sudo
    queue "sudo apt-get -y update"
    queue 'sudo add-apt-repository -y "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"'
    queue 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -'
    queue 'sudo apt-get -y update'
    queue "sudo apt-get -y install postgresql-#{postgresql_version}"
    queue "sudo apt-get -y install libpq-dev"
  end

  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "database.yml.erb"
    queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
  end

  desc "Create database"
  task :create_db do
    queue %{echo "-----> Create database"}
    invoke :sudo
    ask "PostgreSQL password:" do |psql_password|
      psql_password.echo = "x"
      queue echo_cmd %{sudo -u postgres psql -c "create user #{psql_user} with password '#{psql_password}';"}
      queue echo_cmd %{sudo -u postgres psql -c "create database #{psql_database} owner #{psql_user} --template=template0 ENCODING 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8'";}
      queue echo_cmd %{sudo -u postgres psql -c "update pg_database set encoding = pg_char_to_encoding('UTF8') where datname = '#{psql_database}';"}
      template "database.yml.erb"
    end
    pg_ram = nil
    pg_connections = 100
    ask "How many GB do you want to provision to the PostgreSQL database?" do |psql_ram|
      pg_ram = psql_ram.to_i
    end
    ask "And max connections to the PostgreSQL database?" do |psql_max|
      pg_connections = psql_max.to_i
    end
    queue %{echo "-----> Tuning database"}
    conf = Pgcalc.new(pg_ram, pg_connections).to_s.split("\n").join('\n')
    queue %{sudo sh -c "echo '#{conf}' >> /etc/postgresql/9.6/main/postgresql.conf"}
  end

  RYAML = <<-BASH
  function ryaml {
    ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key] }' "$@"
  };
  BASH

  desc 'Pull remote db in development'
  task :pull do
    code = isolate do
      invoke :environment
      queue RYAML
      queue "USERNAME=$(ryaml #{config_path!}/database.yml #{rails_env!} username)"
      queue "PASSWORD=$(ryaml #{config_path!}/database.yml #{rails_env!} password)"
      queue "DATABASE=$(ryaml #{config_path!}/database.yml #{rails_env!} database)"
      queue %{echo "-----> Database $DATABASE will be dumped locally"}
      queue "PGPASSWORD=$PASSWORD pg_dump -w -U $USERNAME $DATABASE -f #{tmp_path}/dump.sql"
      queue "gzip -f #{tmp_path}/dump.sql"
      run!
    end

    %x[scp #{user}@#{domain}:#{tmp_path}/dump.sql.gz .]
    %x[gunzip -f dump.sql.gz]
    %x[#{RYAML} psql -d $(ryaml config/database.yml development database) -f dump.sql]
    %x[rm dump.sql]
  end

end
