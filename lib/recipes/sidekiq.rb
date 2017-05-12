namespace :sidekiq do

  task(:install) {  }

  desc "Setup sidekiq configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "sidekiq.yml.erb", fetch(:sidekiq_config)
    comment "Be sure to edit #{fetch(:sidekiq_config)}"
    template "upstart/sidekiq.conf.erb", "/tmp/sidekiq_conf"
    command "sudo mv /tmp/sidekiq_conf #{fetch(:sidekiq_upstart)}"
  end


  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet => :environment do
    comment "Quiet Sidekiq... (stop accepting new work"
    command "sudo reload #{fetch(:sidekiq_name)}"
  end


  %w[start stop restart].each do |cmd|
    desc "#{cmd.capitalize} sidekiq"
    task cmd => :environment do
      comment "#{cmd.capitalize} Sidekiq..."
      command "sudo #{cmd} #{fetch(:sidekiq_name)}"
    end
  end
end
