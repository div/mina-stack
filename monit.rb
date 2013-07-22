namespace :monit do

  desc "Install Monit"
  task :install do
    queue %{echo "-----> Installing Monit..."}
    queue "sudo apt-get -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    queue %{echo "-----> Setting up Monit..."}
    monit_config "monitrc", "/etc/monit/monitrc"
    # invoke :'monit:nginx'
    # invoke :'monit:postgresql'
    # invoke :'monit:redis'
    invoke :'monit:puma'
    # invoke :'monit:sidekiq'
    invoke :'monit:syntax'
    invoke :'monit:restart'
  end
  after "deploy:setup", "monit:setup"

  task(:nginx) { monit_config "nginx" }
  task(:postgresql) { monit_config "postgresql" }
  task(:redis) { monit_config "redis" }
  task(:puma) { monit_config "puma", "/etc/monit/conf.d/puma_#{app}.conf" }
  task(:sidekiq) { monit_config "sidekiq", "/etc/monit/conf.d/sidekiq_#{app}.conf" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      queue %{echo "-----> Monit #{command}"}
      queue "sudo service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  queue "sudo mv /tmp/monit_#{name} #{destination}"
  queue "sudo chown root #{destination}"
  queue "sudo chmod 600 #{destination}"
end