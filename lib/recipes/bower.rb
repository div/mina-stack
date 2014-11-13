namespace :bower do

  desc "Install bower with dependencies"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Bower..."}
    queue "sudo npm install -g bower"
  end

  task(:setup) {  }

  desc "Install assets"
  task :install_assets do
    if ENV['force_bower']
      invoke :'bower:install_assets:force'
    else
      message = verbose_mode? ?
        '$((count)) changes found, installing asets database' :
        'bower install'

      queue check_for_changes_script \
        :check => 'bower.json',
        :at => ['bower.json'],
        :skip => %[
          echo "-----> bower.json unchanged; skipping"
        ],
        :changed => %[
          echo "-----> #{message}"
          bower install
        ],
        :default => %[
          echo echo "-----> Installing Assets with Bower..."
          bower install
        ]
    end
  end

  task :'install_assets:force' do
    queue %{echo "-----> Installing Assets with Bower..."}
    queue "bower install"
  end

end