
task :initial_setup => :environment do
  invoke :create_extra_paths
  invoke :setup
  invoke :'postgresql:initial_setup'
end

%w(install setup).each do |action|
  desc "#{action.capitalize} Server Stack Services"
  task action.to_sym do
    %w(server_stack app_stack).each do |stack|
      invoke :"#{stack}:#{action}"
    end
  end
end

desc 'Create extra paths for tmp stuff = pids, sockets, etc.'
task :create_extra_paths do
  queue 'echo "-----> Create PID and Sockets paths"'
  queue echo_cmd "mkdir -p #{pids_path} && chown #{user}:#{group} #{pids_path} && chmod +rw #{pids_path}"
  queue echo_cmd "mkdir -p #{sockets_path} && chown #{user}:#{group} #{sockets_path} && chmod +rw #{sockets_path}"
end

namespace :app_stack do
  %w(install setup).each do |action|
    desc "#{action.capitalize} App Stack Services"
    task action.to_sym do
      app_stack.each do |service|
        invoke :"#{service}:#{action}"
      end
    end
  end
end

namespace :server_stack do
  %w(install setup).each do |action|
    desc "#{action.capitalize} Server Stack Services"
    task action.to_sym do
      server_stack += :monit if monitored.any?
      server_stack.each do |service|
        invoke :"#{service}:#{action}"
      end
    end
  end
end