require 'rake'
require 'mina'
require "mina-stack/version"
require 'mina-stack/defaults'
require 'mina-stack/base'
require 'mina-stack/setup'

Dir['config/servers/*.rb'].each { |f| load f }
Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each {|file| require file }