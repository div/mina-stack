namespace :monit do

  desc "Install Monit"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Monit..."}
    queue "sudo apt-get -y install monit"
  end

  desc "Setup all Monit configuration"
  task :setup do
    invoke :sudo
    if monitored.any?
      queue %{echo "-----> Setting up Monit..."}
      monit_config "monitrc", "/etc/monit/monitrc"
      monitored.each do |deamon|
        invoke :"monit:#{deamon}"
      end
      invoke :'monit:syntax'
      invoke :'monit:restart'
    else
      queue %{echo "-----> Skiping monit - nothing is set for monitoring..."}
    end
  end

  task(:nginx) { monit_config "nginx" }
  task(:postgresql) { monit_config "postgresql" }
  task(:redis) { monit_config "redis" }
  task(:memcached) { monit_config "memcached" }
  task(:puma) { monit_config "puma", "#{puma_name}" }
  task(:unicorn) { monit_config "unicorn", "#{unicorn_name}" }
  task(:sidekiq) { monit_config "sidekiq", "#{sidekiq_name}" }
  task(:private_pub) { monit_config "private_pub", "#{private_pub_name}" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      queue %{echo "-----> Monit #{command}"}
      queue "sudo service monit #{command}"
    end
  end
end

def monit_config(origin_name, destination_name = nil)
  destination_name ||= origin_name
  destination = "#{monit_config_path}/#{destination_name}.conf"
  template "monit/#{origin_name}.erb", "/tmp/monit_#{origin_name}"
  queue "sudo mv /tmp/monit_#{origin_name} #{destination}"
  queue "sudo chown root #{destination}"
  queue "sudo chmod 600 #{destination}"
end