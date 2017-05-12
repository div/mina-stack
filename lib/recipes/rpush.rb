namespace :rpush do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "upstart/rpush.conf.erb", "/tmp/rpush_conf"
    command "sudo mv /tmp/rpush_conf #{fetch(:rpush_upstart)}"
  end

  %w[start stop restart reload].each do |cmd|
    desc "#{cmd.capitalize} rpush"
    task cmd do
      comment "#{command.capitalize} rpush."
      command "sudo #{cmd} #{fetch(:rpush_name)}"
    end
  end
end
