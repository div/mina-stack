
%w(install setup).each do |action|
  desc "#{action.capitalize} Server Stack Services"
  task action.to_sym => :environment do
    if action.to_sym == :setup
      invoke :create_extra_paths
      # invoke :create_config_files
    else
      invoke :'libs:install'
    end
    server_stack.each do |service|
      invoke :"#{service}:#{action}"
    end
  end
end

desc 'Create extra paths for shared configs, pids, sockets, etc.'
task :create_extra_paths do
  queue 'echo "-----> Create configs path"'
  queue echo_cmd "mkdir -p #{config_path}"

  queue 'echo "-----> Create shared paths"'
  shared_paths.each do |p|
    queue echo_cmd "mkdir -p #{deploy_to}/#{shared_path}/#{p}" unless p.include?(".")
  end

  shared_dirs = shared_paths.map { |file| File.dirname("#{deploy_to}/#{shared_path}/#{file}") }.uniq
  shared_dirs.map do |dir|
    queue echo_cmd %{mkdir -p "#{dir}"}
  end

  queue 'echo "-----> Create PID and Sockets paths"'
  queue echo_cmd "mkdir -p #{pids_path} && chown #{user}:#{group} #{pids_path} && chmod +rw #{pids_path}"
  queue echo_cmd "mkdir -p #{sockets_path} && chown #{user}:#{group} #{sockets_path} && chmod +rw #{sockets_path}"

  if monitored.any?
    queue 'echo "-----> Create Monit dir"'
    queue echo_cmd "mkdir -p #{config_path}/monit && chown #{user}:#{group} #{config_path}/monit && chmod +rw #{config_path}/monit"
  end
end

desc 'Create config files'
task :create_config_files do
  template "secrets.yml.erb"
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]
end
