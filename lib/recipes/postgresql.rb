namespace :postgresql do

  require 'highline/import'

  desc "Install the latest stable release of PostgreSQL."
  task :install do
    invoke :sudo
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install postgresql postgresql-contrib"
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
      queue echo_cmd %{sudo -u postgres psql -c "create database #{psql_database} owner #{psql_user};"}
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
