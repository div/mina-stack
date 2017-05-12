task :defaults do
  set :ruby_version,          "2.3.1"
  set :services_path,         "/etc/init.d"
  set :upstart_path,          "/etc/init"
  set :tmp_path,              "#{fetch(:shared_path)}/tmp"
  set :sockets_path,          "#{fetch(:tmp_path)}/sockets"
  set :pids_path,             "#{fetch(:tmp_path)}/pids"
  set :logs_path,             "#{fetch(:shared_path)}/log"
  set :config_path,           "#{fetch(:current_path)}/config"
  set :app_namespace,         "#{fetch(:app)}_#{fetch(:rails_env)}"
  set :bundle,                "cd #{fetch(:current_path)} && #{fetch(:bundle_bin)}"

  set :term_mode,             :pretty

  set :psql_user,             "#{fetch(:app)}"
  set :psql_database,         "#{fetch(:app_namespace)}"
  set :postgresql_version,    "9.6"
  set :postgresql_pid,        "/var/run/postgresql/#{fetch(:postgresql_version)}-main.pid"

  set :nginx_client_max_body_size, "4M"
  set :cloudflare_ssl,        true

  set :memcached_pid,         "/var/run/memcached.pid"

  set :unicorn_name,          "unicorn_#{fetch(:app_namespace!)}"
  set :unicorn_socket,        "#{fetch(:sockets_path)}/unicorn.sock"
  set :unicorn_pid,           "#{fetch(:pids_path)}/unicorn.pid"
  set :unicorn_config,        "#{fetch(:config_path)}/unicorn.rb"
  set :unicorn_log,           "#{fetch(:logs_path)}/unicorn.log"
  set :unicorn_error_log,     "#{fetch(:logs_path)}/unicorn.error.log"
  set :unicorn_script,        "#{fetch(:services_path!)}/#{fetch(:unicorn_name)}"
  set :unicorn_workers,       1
  set :unicorn_bin,           lambda { "#{fetch(:bundle_bin)} exec unicorn" }
  set :unicorn_cmd,           "cd #{fetch(:current_path)} && #{fetch(:unicorn_bin)} -D -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)}"
  set :unicorn_user,          fetch(:user)
  set :unicorn_group,         fetch(:user)

  set :nginx_pid,             "/var/run/nginx.pid"
  set :nginx_config,          "#{fetch(:nginx_path)}/sites-available/#{fetch(:app_namespace)}.conf"
  set :nginx_config_e,        "#{fetch(:nginx_path)}/sites-enabled/#{fetch(:app_namespace)}.conf"

  set :sidekiq_name,          "sidekiq_#{fetch(:app_namespace)}"
  set :sidekiq_cmd,           lambda { "#{fetch(:bundle_bin)} exec sidekiq" }
  set :sidekiqctl_cmd,        lambda { "#{fetch(:bundle_prefix)} sidekiqctl" }
  set :sidekiq_timeout,       10
  set :sidekiq_config,        "#{fetch(:config_path)}/sidekiq.yml"
  set :sidekiq_log,           "#{fetch(:logs_path)}/sidekiq.log"
  set :sidekiq_pid,           "#{fetch(:pids_path)}/sidekiq.pid"
  set :sidekiq_concurrency,   25
  set :sidekiq_start,         "#{fetch(:sidekiq_cmd)} -e #{fetch(:rails_env)} -C #{fetch(:sidekiq_config)}"
  set :sidekiq_upstart,       "#{fetch(:upstart_path)}/#{fetch(:sidekiq_name)}.conf"

  set :private_pub_name,      "private_pub_#{fetch(:app_namespace)}"
  set :private_pub_cmd,       lambda { "#{fetch(:bundle_prefix)} rackup private_pub.ru" }
  set :private_pub_pid,       "#{fetch(:pids_path)}/private_pub.pid"
  set :private_pub_config,    "#{fetch(:config_path)}/private_pub.yml"
  set :private_pub_log,       "#{fetch(:logs_path)}/private_pub.log"

  set :rpush_name,            "rpush_#{fetch(:app_namespace!)}"
  set :rpush_cmd,             lambda { "#{fetch(:bundle_bin)} exec rpush" }
  set :rpush_upstart,         "#{fetch(:upstart_path)}/#{fetch(:rpush_name)}.conf"
  set :rpush_start,           "#{fetch(:rpush_cmd)} start -f -e #{fetch(:rails_env)}"

  set :puma_name,             "puma_#{fetch(:app_namespace)}"
  set :puma_cmd,              lambda { "#{fetch(:bundle_bin)} exec puma" }
  set :pumactl_cmd,           lambda { "#{fetch(:bundle_bin)} exec pumactl" }
  set :puma_config,           "#{fetch(:current_path)}/puma.rb"
  set :puma_pid,              "#{fetch(:pids_path)}/puma.pid"
  set :puma_log,              "#{fetch(:logs_path)}/puma.log"
  set :puma_error_log,        "#{fetch(:logs_path)}/puma.err.log"
  set :puma_socket,           "#{fetch(:sockets_path)}/puma.sock"
  set :puma_state,            "#{fetch(:sockets_path)}/puma.state"
  set :puma_upstart,          "#{fetch(:upstart_path)}/#{fetch(:puma_name)}.conf"
  set :puma_workers,          2
  set :puma_start,            "#{fetch(:puma_cmd)} -C #{fetch(:puma_config)}"

  set :monit_config_path,     "/etc/monit/conf.d"
  set :monit_http_port,       2812
  set :monit_http_username,   "PleaseChangeMe_monit"
  set :monit_http_password,   "PleaseChangeMe"

  set :shared_files,                  %w(
                                      /home/deploy/apps/kioskable/current/config/puma.rb
                                      config/database.yml
                                      config/application.yml
                                      config/sidekiq.yml
                                    )

  set :shared_dirs,                 %w(
                                      tmp
                                      log
                                      )
  set :monitored,             %w(
                                        nginx
                                        postgresql
                                        redis
                                        puma
                                        sidekiq
                                        private_pub
                                        memcached
                                        )

  set :server_stack,          %w(
                                        nginx
                                        postgresql
                                        redis
                                        rails
                                        rbenv
                                        puma
                                        sidekiq
                                        private_pub
                                        elastic_search
                                        imagemagick
                                        memcached
                                        monit
                                        bower
                                        node
                                      )

end
