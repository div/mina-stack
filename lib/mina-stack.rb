require 'rake'
require 'securerandom'
require 'mina'
require "mina-stack/version"
require 'mina-stack/defaults'
require 'mina-stack/base'
require 'mina-stack/setup'
require 'mina-stack/pgcalc'

Dir['config/servers/*.rb'].each { |f| load f }
Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each {|file| require file }
