namespace :psql do

  require 'highline/import'

  desc "Setup database"
  task :setup => [:upload, :create_db]

  desc "Create configuration and other files"
  task :upload do
    template "database.yml.erb"
  end

  desc "Create database"
  task :create_db do
    queue %{echo "-----> Create database"}
    invoke :sudo
    ask "PostgreSQL password:" do |password|
      queue echo_cmd %{sudo -u postgres psql -c "create user #{psql_user} with password '#{password}';"}
      queue echo_cmd %{sudo -u postgres psql -c "create database #{psql_database} owner #{psql_user};"}
    end
  end

end