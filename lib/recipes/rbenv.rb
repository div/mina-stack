namespace :rbenv do

  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install do
    invoke :sudo
    comment "Checking to see if #{fetch(:ruby_version)} exists on server..."
    #  if(echo $(rbenv versions) | grep -q "2.3.1") then echo "i am here"; else echo "nope"; fi
    comment "Installing Ruby"
    command "sudo apt-get -y install curl git-core"
    command "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
    bashrc = <<-BASHRC
      if [ -d $HOME/.rbenv ]; then
        export PATH="$HOME/.rbenv/bin:$PATH"
        eval "$(rbenv init -)"
      fi
    BASHRC
    put bashrc, "/tmp/rbenvrc"
    command "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
    command "mv ~/.bashrc.tmp ~/.bashrc"
    command %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    command %q{eval "$(rbenv init -)"}
    command "sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev"
    command "rbenv install #{fetch(:ruby_version)}"
    command "rbenv global #{fetch(:ruby_version)}"
    command "gem install bundler --no-ri --no-rdoc"
    command "rbenv rehash"
  end

  task(:setup) {  }
end
