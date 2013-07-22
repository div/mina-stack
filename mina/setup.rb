task :initial_setup => :environment do
  invoke :create_extra_paths
  invoke :create_config_files
  invoke :setup
  invoke :'psql:setup'
end

task :setup => :environment do
  invoke :'nginx:setup'
  invoke :'puma:setup'
  invoke :'sidekiq:setup'
  invoke :'private_pub:setup'
  # invoke :'monit:setup'
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
  cmds = shared_dirs.map do |dir|
    queue echo_cmd %{mkdir -p "#{dir}"}
  end

  queue 'echo "-----> Create PID and Sockets paths"'
  queue echo_cmd "mkdir -p #{pids_path} && chown #{user}:#{group} #{pids_path} && chmod +rw #{pids_path}"
  queue echo_cmd "mkdir -p #{sockets_path} && chown #{user}:#{group} #{sockets_path} && chmod +rw #{sockets_path}"
end

desc 'Create config files'
task :create_config_files do
  template "application.yml.erb"
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]
end