require 'mina-ubuntu/defaults'
require 'mina-ubuntu/base'
require 'mina-ubuntu/setup'

Dir['config/servers/*.rb'].each { |f| load f }

set_default :server_stack,          %w(
                                      nginx
                                      postgresql
                                      redis
                                      rails
                                      rbenv
                                      puma
                                      sidekiq
                                      private_pub
                                      elastic_search
                                      imagemagick
                                      memcached
                                      monit
                                      bower
                                    )

server_stack.each do |service|
  require "mina-ubuntu/recipes/#{service}"
end

set_default :rails_socket, lambda { server_stack.include?("puma") ? puma_socket : unicorn_socket }