namespace :private_pub do

  desc "Setup Private Pub configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "private_pub.yml.erb", private_pub_config
    queue  %[echo "-----> Be sure to edit #{private_pub_config}."]
  end

  desc "Stop Private Pub"
  task :stop do
    queue %[ if [ -f #{private_pub_pid} ]; then
      echo "-----> Stop Private Pub"
      kill -s QUIT `cat #{private_pub_pid}` || true
      fi ]
  end

  desc "Start Private Pub"
  task :start do
    queue %{
      echo "-----> Start Private Pub"
      #{echo_cmd %[(cd #{deploy_to}/#{current_path}; #{private_pub_cmd} -s thin -E #{rails_env} -P #{private_pub_pid} >> #{private_pub_log} 2>&1 </dev/null &) ] }
      }
  end

  desc "Restart Private Pub"
  task :restart do
    invoke :'private_pub:stop'
    invoke :'private_pub:start'
  end
end