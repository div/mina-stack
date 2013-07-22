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

  task(:initial_setup) => [:upload, :create_db]

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
      queue echo_cmd %{sudo -u postgres psql -c "create user #{psql_user} with password '#{psql_password}';"}
      queue echo_cmd %{sudo -u postgres psql -c "create database #{psql_database} owner #{psql_user};"}
    end
  end

end