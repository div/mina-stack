namespace :phobos do

  task(:install) {  }

  desc "Setup Phobos configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "upstart/phobos.conf.erb", "/tmp/phobos_conf"
    queue "sudo mv /tmp/phobos_conf #{phobos_upstart}"
  end

  %w[start stop restart reload].each do |command|
    desc "#{command.capitalize} phobos"
    task command do
      queue "sudo #{command} #{phobos_name}"
      queue  %[echo "-----> #{command.capitalize} phobos."]
    end
  end
end
