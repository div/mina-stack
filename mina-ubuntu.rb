require 'mina-ubuntu/defaults'
require 'mina-ubuntu/base'
require 'mina-ubuntu/setup'

Dir['config/servers/*.rb'].each { |f| load f }
Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each {|file| require file }