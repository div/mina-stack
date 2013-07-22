namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    invoke :sudo
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    queue "chmod +x /tmp/unicorn_init"
    queue "sudo mv /tmp/unicorn_init #{unicorn_script}"
    queue "sudo update-rc.d -f #{unicorn_script} defaults"
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      queue "service #{unicorn_name} #{command}"
    end
  end
end