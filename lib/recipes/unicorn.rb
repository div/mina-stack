namespace :unicorn do

  task(:install) {  }

  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    invoke :sudo
    template "unicorn.rb.erb", fetch(:unicorn_config)
    template "unicorn_init.erb", "/tmp/unicorn_init"
    command "chmod +x /tmp/unicorn_init"
    command "sudo mv /tmp/unicorn_init #{fetch(:unicorn_script)}"
    command "sudo update-rc.d -f #{fetch(:unicorn_name)} defaults"
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd} unicorn"
    task cmd do
      comment "service #{fetch(:unicorn_name)} #{cmd}"
    end
  end
end