namespace :sidekiq do

  task(:install) {  }

  desc "Setup sidekiq configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "sidekiq.yml.erb", sidekiq_config
    queue  %[echo "-----> Be sure to edit #{sidekiq_config}."]
    template "upstart/sidekiq.conf.erb", "/tmp/sidekiq_conf"
    queue "sudo mv /tmp/sidekiq_conf #{sidekiq_upstart}"
  end


  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet => :environment do
    queue "pgrep -f '#{sidekiq_name}' | xargs kill -USR1"
    queue  %[echo "-----> Quiet sidekiq (stop accepting new work)."]
  end


  %w[start stop restart].each do |command|
    desc "#{command.capitalize} sidekiq"
    task command => :environment do
      queue "sudo #{command} #{sidekiq_name}"
      queue  %[echo "-----> #{command.capitalize} sidekiq."]
    end
  end
end
