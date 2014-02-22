STACKS = [:server_stack, :utils, :app_stack]
ACTIONS = [:install, :setup]

namespace :ms do

  desc 'Setups paths for app'
  task :create_dirs do
    queue %{
      echo "-----> Setting up #{deploy_to}" && (
        #{echo_cmd %{mkdir -p "#{deploy_to}"}} &&
        #{echo_cmd %{chown -R `whoami` "#{deploy_to}"}} &&
        #{echo_cmd %{chmod g+rx,u+rwx "#{deploy_to}"}} &&
        echo "" &&
        #{echo_cmd %{ls -la "#{deploy_to}"}} &&
        echo "" &&
        echo "-----> Done."
      ) || (
        echo "! ERROR: Setup failed."
        echo "! Ensure that the path '#{deploy_to}' is accessible to the SSH user."
        echo "! Try doing:"
        echo "!    sudo mkdir -p \\"#{deploy_to}\\" && sudo chown -R #{user} \\"#{deploy_to}\\""
      )
    }
  end

  task :tmp_dirs do
    queue %{
      echo "-----> Setting up tmp paths" && (
        #{echo_cmd %{cd "#{deploy_to}"}} &&
        #{echo_cmd %{mkdir -p "#{tmp_path}"}} &&
        #{echo_cmd %{chmod g+rx,u+rwx "#{tmp_path}"}} &&
        #{echo_cmd %{mkdir -p "#{pids_path}"}} &&
        #{echo_cmd %{chmod g+rx,u+rwx "#{pids_path}"}} &&
        #{echo_cmd %{mkdir -p "#{sockets_path}"}} &&
        #{echo_cmd %{chmod g+rx,u+rwx "#{sockets_path}"}} &&
        #{echo_cmd %{mkdir -p "#{config_path}"}} &&
        #{echo_cmd %{chmod g+rx,u+rwx "#{config_path}"}} &&
        echo ""
      )
    }
  end

  task :setup do
    invoke :'ms:create_dirs'
    invoke :'git:fetch'
    invoke :'ms:tmp_dirs'
  end


  ACTIONS.each do |action|

    STACKS.each do |stack|
      namespace stack do
        desc "#{action.capitalize} #{stack}"
        task action do
          send(stack).each do |service|
            invoke :"#{service}:#{action}"
          end
        end
      end
    end

    desc "#{action.capitalize} All Stack Services"
    task action do
      STACKS.each do |stack|
        invoke :"ms:#{stack}:#{action}"
      end
    end

  end
end