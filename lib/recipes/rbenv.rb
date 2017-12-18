namespace :rbenv do

  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Ruby"}
    queue "sudo apt-get -y install curl git-core"
    queue "curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash"
    bashrc = <<-BASHRC
      if [ -d $HOME/.rbenv ]; then
        export PATH="$HOME/.rbenv/bin:$PATH"
        eval "$(rbenv init -)"
      fi
    BASHRC
    put bashrc, "/tmp/rbenvrc"
    queue "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
    queue "mv ~/.bashrc.tmp ~/.bashrc"
    queue %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    queue %q{eval "$(rbenv init -)"}
    queue "sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev"
    queue "rbenv install #{ruby_version}"
    queue "rbenv global #{ruby_version}"
    queue "gem install bundler --no-ri --no-rdoc"
    queue "rbenv rehash"
  end

  task(:setup) {  }
end
