require 'mina-ubuntu/defaults'
require 'mina-ubuntu/base'
require 'mina-ubuntu/setup'

Dir['config/servers/*.rb'].each { |f| load f }

server_stack.each do |service|
  require "mina-ubuntu/recipes/#{service}"
end