require 'rails/generators/base'

module Mina
  module Stack
    module Generators
      class InstallGenerator < Rails::Generators::Base

        source_root File.expand_path("../../templates", __FILE__)
        desc "Creates an deploy script and server config for your application."

        def do_all
          create_servers_directory
          copy_server_example
          copy_deploy_script
          message = <<-RUBY

          Install complete! See the README on Github for instructions on getting your
          deploy running with mina-stack.

          RUBY
          puts message.strip_heredoc

        end

        private

        def create_servers_directory
          # Creates empty directory if none; doesn't empty the directory
          empty_directory "config/servers"
        end

        def copy_server_example
          template "production.rb", "config/servers/production.rb"
        end

        def copy_deploy_script
          template "deploy.rb", "config/deploy.rb"
        end

      end
    end
  end
end