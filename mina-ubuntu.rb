require 'defaults'
require 'base'
require 'setup'
require 'logs'

server_stack.each do |app|
  require app
end

Dir['config/servers/*.rb'].each { |f| load f }