namespace :monit do

  desc "Install Monit"
  task :install do
    invoke :sudo
    comment "Installing Monit..."
    command "sudo apt-get -y install monit"
  end

  desc "Setup all Monit configuration"
  task :setup => :environment do
    invoke :sudo
    if fetch(:monitored, []).any?
      comment "Setting up Monit..."
      fetch(:monitored).each do |daemon|
        invoke :"monit:#{daemon}"
      end
      invoke :"monit:syntax"
      invoke :"monit:restart"
    else
      comment "Skipping monit - nothing is set for monitoring..."
    end
  end

  task(:nginx) { monit_config "nginx" }
  task(:postgresql) { monit_config "postgresql" }
  task(:redis) { monit_config "redis" }
  task(:memcached) { monit_config "memcached" }
  task(:puma) { monit_config "puma", "#{fetch(:puma_name)}" }
  task(:unicorn) { monit_config "unicorn", "#{fetch(:unicorn_name)}" }
  task(:sidekiq) { monit_config "sidekiq", "#{fetch(:sidekiq_name)}" }
  task(:private_pub) { monit_config "private_pub", "#{fetch(:private_pub_name)}" }

  %w[start stop restart syntax reload].each do |cmd|
    desc "Run Monit #{cmd} script"
    task cmd do
      invoke :sudo
      comment "Monit #{cmd}"
      command "sudo service monit #{cmd}"
    end
  end
end

def monit_config(original_name, destination_name = nil)
  destination_name ||= original_name
  path ||= fetch(:monit_config_path)
  destination = "#{path}/#{destination_name}"
  puts "dest..."
  puts destination
                                              # file name in /home/deploy/apps/app/shared/config/monit
  template "monit/#{original_name}.erb", "#{fetch(:config_path)}/monit/#{original_name}.monitrc"
  puts destination
  command echo_cmd %{sudo ln -s "#{fetch(:config_path)}/monit/#{original_name}.monitrc" "#{destination}.monitrc"}
  command check_symlink destination
  # queue "sudo mv /tmp/monit_#{original_name} #{destination}"
  # queue "sudo chown root #{destination}"
  # queue "sudo chmod 600 #{destination}"
end