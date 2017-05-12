namespace :private_pub do

  task(:install) {  }

  desc "Setup Private Pub configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "private_pub.yml.erb", fetch(:private_pub_config)
    comment "Be sure to edit #{fetch(:private_pub_config)}."
  end

  desc "Stop Private Pub"
  task :stop do
    command %[ if [ -f #{fetch(:private_pub_pid)} ]; then
      echo "-----> Stop Private Pub"
      kill -s QUIT `cat #{fetch(:private_pub_pid)}` || true
      fi ]
  end

  desc "Start Private Pub"
  task :start do
    command %{
      echo "-----> Start Private Pub"
      #{echo_cmd %[(cd #{fetch(:current_path)}; #{fetch(:private_pub_cmd)} -s #{fetch(:private_pub_server)} -E #{fetch(:rails_env)} -P #{fetch(:private_pub_pid)} >> #{fetch(:private_pub_log)} 2>&1 </dev/null &) ] }
      }
  end

  desc "Restart Private Pub"
  task :restart do
    invoke :'private_pub:stop'
    invoke :'private_pub:start'
  end
end