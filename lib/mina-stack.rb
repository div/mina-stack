require 'rake'
require 'mina'
require 'mina-stack/deploy_helpers'
require 'mina-stack/version'
require 'mina-stack/defaults'
require 'mina-stack/base'

Dir['config/servers/*.rb'].each { |f| load f }
Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each {|file| require file }

require 'mina-stack/setup'

module Mina
  module Stack
    def self.root_path(*a)
      File.join File.expand_path('../../', __FILE__), *a
    end
  end
end