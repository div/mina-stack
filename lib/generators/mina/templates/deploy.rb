$:.unshift './lib'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina-stack'

set :app,                 'example'
set :server_name,         'example.com'
set :keep_releases,       9999
set :default_server,      :production
set :server, ENV['to'] || default_server
invoke :"env:#{server}"

# Allow calling as `mina deploy at=master`
set :branch, ENV['at']  if ENV['at']

set :server_stack,                  %w(
                                      nginx
                                      postgresql
                                      redis
                                      rbenv
                                      puma
                                      sidekiq
                                      private_pub
                                      elastic_search
                                      imagemagick
                                      memcached
                                      monit
                                      node
                                      bower
                                    )

set :shared_paths,                  %w(
                                      tmp
                                      log
                                      config/puma.rb
                                      config/database.yml
                                      config/application.yml
                                      config/sidekiq.yml
                                      public/uploads
                                    )

set :monitored,                     %w(
                                      nginx
                                      postgresql
                                      redis
                                      puma
                                      sidekiq
                                      private_pub
                                      memcached
                                    )

task :environment do
  invoke :'rbenv:load'
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'bower:install_assets'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:restart'
      invoke :'private_pub:restart'
    end
  end
end