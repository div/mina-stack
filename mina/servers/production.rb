namespace :env do
  task :production => [:environment] do
    set :domain,              '198.211.124.239'
    set :user,                'deployer'
    set :deploy_to,           "/home/#{user}/apps/#{app}"
    set :repository,          "/home/#{user}/git/#{app}"
    set :services_path,       '/usr/local/etc/rc.d'          # where your God and Unicorn service control scripts will go
    set :nginx_path,          '/etc/nginx'
    set :deploy_server,       'production'                   # just a handy name of the server
    set :rails_env,           'production'
    set :branch,              'master'
    invoke :defaults                                         # load rest of the config
  end
end