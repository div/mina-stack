require 'mina-ubuntu/defaults'
require 'mina-ubuntu/base'
require 'mina-ubuntu/setup'
require 'mina-ubuntu/logs'

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
                                      elastc_search
                                      imagemagick
                                      memcached
                                      monit
                                      bower
                                    )

server_stack.each do |service|
  require "mina-ubuntu/#{service}"
end