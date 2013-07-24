namespace :psql do

  require 'highline/import'

  desc "Install the latest stable release of PostgreSQL."
  task :install do
    invoke :sudo
    queue "sudo add-apt-repository ppa:pitti/postgresql --yes"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install postgresql libpq-dev"
  end

  task(:setup) {  }

  task :initial_setup => [:upload, :create_db]

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

  task :pull do
    isolate do
      queue RYAML
      queue "USERNAME=$(ryaml ./shared/config/database.yml #{rails_env} username)"
      queue "PASSWORD=$(ryaml ./shared/config/database.yml #{rails_env} password)"
      queue "DATABASE=$(ryaml ./shared/config/database.yml #{rails_env} database)"
      queue "PGPASSWORD=$PASSWORD pg_dump -U $USERNAME $DATABASE -c -f dump.sql"
      queue "gzip -f dump.sql"

      mina_cleanup!
    end

    %x[scp #{user}@#{domain}:#{deploy_to}/dump.sql.gz .]
    %x[gunzip -f dump.sql.gz]
    %x[#{RYAML} psql -d $(ryaml config/database.yml development database) -f dump.sql]
    %x[rm dump.sql]
  end

end