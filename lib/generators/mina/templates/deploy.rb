require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina-stack'

set :app,                 'example'
set :port,                22
set :server_name,         'example.com'
set :keep_releases,       7
set :default_server,      :production
set :cloudflare_ssl,       true
set :nginx_client_max_body_size, '4M'

set :server, ENV['on'] || fetch(:default_server)
invoke :env, fetch(:server)

# Allow calling as `mina deploy at=master`
set :branch, ENV['at']  if ENV['at']

set :server_stack,                  %w(
                                      nginx
                                      postgresql
                                      redis
                                      rbenv
                                      puma
                                      sidekiq
                                      monit
                                      node
                                    )

set :shared_paths,                  %w(
                                      tmp
                                      log
                                      config/puma.rb
                                      config/database.yml
                                      config/application.yml
                                      config/sidekiq.yml
                                    )

set :monitored,                     %w(
                                      nginx
                                      postgresql
                                      redis
                                      puma
                                      sidekiq
                                    )

set :allowed_ports, %w(443 80 22)

task :environment do
  invoke :rbenv, :load
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :sidekiq, :quiet
    invoke :git, :clone
    invoke :deploy, :link_shared_paths
    invoke :bundle, :install
    invoke :rails, :db_migrate
    invoke :rails, :assets_precompile

    to :launch do
      invoke :puma, :restart
      invoke :sidekiq, :restart
    end
  end
end
