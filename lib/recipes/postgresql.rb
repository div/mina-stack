namespace :postgresql do

  require 'highline/import'

  desc "Install the latest stable release of PostgreSQL."
  task :install do
    invoke :sudo
    command "sudo apt-get -y update"
    command 'sudo add-apt-repository -y "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"'
    command 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -'
    command 'sudo apt-get -y update'
    command "sudo apt-get -y install postgresql-#{fetch(:postgresql_version)}"
    command "sudo apt-get -y install libpq-dev"
  end

  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "database.yml.erb"
    comment "Be sure to edit 'shared/config/database.yml'."
  end

  desc "Create database"
  task :create_db do
    comment "Create database."
    invoke :sudo
    psql_password = ask "PostgreSQL password:"
    set :psql_password, psql_password.strip
    command echo_cmd %{sudo -u postgres psql -c "create user #{fetch(:psql_user)} with password '#{fetch(:psql_password)}';"}
    command echo_cmd %{sudo -u postgres psql -c "create database #{fetch(:psql_database)} owner #{fetch(:psql_user)} --template=template0 ENCODING 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8'";}
    command echo_cmd %{sudo -u postgres psql -c "update pg_database set encoding = pg_char_to_encoding('UTF8') where datname = '#{fetch(:psql_database)}';"}
    command echo_cmd %{sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE #{fetch(:psql_database)} TO #{fetch(:psql_user)};"}
    template "database.yml.erb"
    tune = ask "Do you want to tune your database? [Y/n]"
    unless tune == 'n'
      pg_ram = ask "How many GB do you want to provision to the PostgreSQL database?"
      pg_ram = pg_ram.to_i
      pg_connections = ask "And max connections to the PostgreSQL database?"
      pg_connections = pg_connections.to_i

      comment "Tuning database."
      conf = Pgcalc.new(pg_ram, pg_connections).to_s.split("\n").join('\n')
      command %{sudo sh -c "echo '#{conf}' >> /etc/postgresql/#{fetch(:postgresql_version)}/main/postgresql.conf"}
      command "Tuned. Restarting postgresql service."
      command echo_cmd %{sudo service postgresql restart}
    end
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
      command RYAML
      command "USERNAME=$(ryaml #{fetch(:config_path!)}/database.yml #{fetch(:rails_env!)} username)"
      command "PASSWORD=$(ryaml #{fetch(:config_path!)}/database.yml #{fetch(:rails_env!)} password)"
      command "DATABASE=$(ryaml #{fetch(:config_path!)}/database.yml #{fetch(:rails_env!)} database)"
      comment "Database $DATABASE will be dumped locally"
      command "PGPASSWORD=$PASSWORD pg_dump -w -U $USERNAME $DATABASE -f #{fetch(:tmp_path)}/dump.sql"
      command "gzip -f #{fetch(:tmp_path)}/dump.sql"
      run!
    end

    %x[scp #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:tmp_path)}/dump.sql.gz .]
    %x[gunzip -f dump.sql.gz]
    %x[#{RYAML} psql -d $(ryaml config/database.yml development database) -f dump.sql]
    %x[rm dump.sql]
  end

end
