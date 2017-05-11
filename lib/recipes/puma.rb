namespace :puma do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "puma.rb.erb", puma_config
    queue  %[echo "-----> Be sure to edit #{puma_config}."]
    template "upstart/puma.conf.erb", "/tmp/puma_conf"
    queue "sudo mv /tmp/puma_conf #{puma_upstart}"
  end

  %w[start stop restart].each do |command|
    desc "#{command.capitalize} puma"
    task command do
      queue  %[echo "-----> #{command.capitalize} puma."]
      queue "sudo #{command} #{puma_name}"
    end
  end

  desc "Phased-restart puma"
  task :'phased-restart' do
    queue  %[echo "-----> Phased-restart puma."]
    queue "sudo reload #{puma_name}"
  end

end
