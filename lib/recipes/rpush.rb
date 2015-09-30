namespace :rpush do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "upstart/rpush.conf.erb", "/tmp/rpush_conf"
    queue "sudo mv /tmp/rpush_conf #{rpush_upstart}"
  end

  %w[start stop restart reload].each do |command|
    desc "#{command.capitalize} rpush"
    task command do
      queue "sudo #{command} #{rpush_name}"
      queue  %[echo "-----> #{command.capitalize} rpush."]
    end
  end
end
