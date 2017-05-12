
%w(install setup).each do |action|
  desc "#{action.capitalize} Server Stack Services"
  task action.to_sym => :environment do
    if action.to_sym == :setup
      invoke :create_extra_paths
      # invoke :create_config_files
    else
      invoke :'libs:install'
    end
    fetch(:server_stack, []).each do |service|
      invoke :"#{service.to_sym}:#{action}"
    end
  end
end

desc 'Create extra paths for shared configs, pids, sockets, etc.'
task :create_extra_paths do
  comment 'Create configs path'
  command echo_cmd "mkdir -p #{fetch(:config_path)}"

  comment "Create shared paths"
  fetch(:shared_dirs, []).each do |p|
    command echo_cmd "mkdir -p #{fetch(:shared_path)}/#{p}" unless p.include?(".")
  end

  shared_dirs = fetch(:shared_dirs).map { |file| File.dirname("#{fetch(:shared_path)}/#{file}") }.uniq
  shared_dirs.map do |dir|
    command echo_cmd %{mkdir -p "#{dir}"}
  end

  comment 'Create PID and Sockets paths'
  command echo_cmd "mkdir -p #{fetch(:pids_path)} && chown #{fetch(:user)}:#{fetch(:group)} #{fetch(:pids_path)} && chmod +rw #{fetch(:pids_path)}"
  command echo_cmd "mkdir -p #{fetch(:sockets_path)} && chown #{fetch(:user)}:#{fetch(:group)} #{fetch(:sockets_path)} && chmod +rw #{fetch(:sockets_path)}"

  if fetch(:monitored, []).any?
    comment 'Create Monit dir'
    command echo_cmd "mkdir -p #{fetch(:config_path)}/monit && chown #{fetch(:user)}:#{fetch(:group)} #{fetch(:config_path)}/monit && chmod +rw #{fetch(:config_path)}/monit"
    fetch(:monitored, []).each do |p|
      path = "#{fetch(:config_path)}/monit/#{p}"
      command echo_cmd "mkdir -p #{fetch(:path)} && chown #{fetch(:user)}:#{fetch(:group)} #{fetch(:path)} && chmod +rw #{path}"
    end
  end
end

desc 'Create config files'
task :create_config_files do
  template "secrets.yml.erb"
  comment "echo Be sure to edit 'shared/config/secrets.yml'"
end
