namespace :node do
  desc "Install the latest relase of Node.js with nvm"
  task :install do
    queue 'git clone git://github.com/creationix/nvm.git ~/.nvm'
    queue %[echo '[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"' >> ~/.bashrc]
    queue 'nvm install 0.10'
    queue 'nvm use 0.10'
  end
  task(:setup) {  }
end