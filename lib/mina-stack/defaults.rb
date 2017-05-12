task :defaults do
  set_default :ruby_version,          "2.3.1"
  set_default :services_path,         "/etc/init.d"
  set_default :upstart_path,          "/etc/init"
  set_default :tmp_path,              "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp"
  set_default :sockets_path,          "#{fetch(:tmp_path)}/sockets"
  set_default :pids_path,             "#{fetch(:tmp_path)}/pids"
  set_default :logs_path,             "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log"
  set_default :config_path,           "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config"
  set_default :app_namespace,         "#{fetch(:app!)}_#{fetch(:rails_env!)}"
  set_default :bundle,                "cd #{fetch(:deploy_to)}/#{fetch(:current_path)} && #{fetch(:bundle_bin)}"

  set_default :term_mode,             :pretty

  set_default :psql_user,             "#{fetch(:app!)}"
  set_default :psql_database,         "#{fetch(:app_namespace)}"
  set_default :postgresql_version,    "9.6"
  set_default :postgresql_pid,        "/var/run/postgresql/#{fetch(:postgresql_version)}-main.pid"

  set_default :nginx_client_max_body_size, "4M"
  set_default :cloudflare_ssl,        true

  set_default :memcached_pid,         "/var/run/memcached.pid"

  set_default :unicorn_name,          "unicorn_#{fetch(:app_namespace!)}"
  set_default :unicorn_socket,        "#{fetch(:sockets_path)}/unicorn.sock"
  set_default :unicorn_pid,           "#{fetch(:pids_path)}/unicorn.pid"
  set_default :unicorn_config,        "#{fetch(:config_path)}/unicorn.rb"
  set_default :unicorn_log,           "#{fetch(:logs_path)}/unicorn.log"
  set_default :unicorn_error_log,     "#{fetch(:logs_path)}/unicorn.error.log"
  set_default :unicorn_script,        "#{fetch(:services_path!)}/#{fetch(:unicorn_name)}"
  set_default :unicorn_workers,       1
  set_default :unicorn_bin,           lambda { "#{fetch(:bundle_bin)} exec unicorn" }
  set_default :unicorn_cmd,           "cd #{fetch(:deploy_to)}/#{fetch(:current_path)} && #{fetch(:unicorn_bin)} -D -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)}"
  set_default :unicorn_user,          user
  set_default :unicorn_group,         user

  set_default :nginx_pid,             "/var/run/nginx.pid"
  set_default :nginx_config,          "#{fetch(:nginx_path!)}/sites-available/#{fetch(:app_namespace!)}.conf"
  set_default :nginx_config_e,        "#{fetch(:nginx_path!)}/sites-enabled/#{fetch(:app_namespace!)}.conf"

  set_default :sidekiq_name,          "sidekiq_#{fetch(:app_namespace!)}"
  set_default :sidekiq_cmd,           lambda { "#{fetch(:bundle_bin)} exec sidekiq" }
  set_default :sidekiqctl_cmd,        lambda { "#{fetch(:bundle_prefix)} sidekiqctl" }
  set_default :sidekiq_timeout,       10
  set_default :sidekiq_config,        "#{fetch(:config_path)}/sidekiq.yml"
  set_default :sidekiq_log,           "#{fetch(:logs_path)}/sidekiq.log"
  set_default :sidekiq_pid,           "#{fetch(:pids_path)}/sidekiq.pid"
  set_default :sidekiq_concurrency,   25
  set_default :sidekiq_start,         "#{fetch(:sidekiq_cmd)} -e #{fetch(:rails_env)} -C #{fetch(:sidekiq_config)}"
  set_default :sidekiq_upstart,       "#{fetch(:upstart_path!)}/#{fetch(:sidekiq_name)}.conf"

  set_default :private_pub_name,      "private_pub_#{fetch(:app_namespace)}"
  set_default :private_pub_cmd,       lambda { "#{fetch(:bundle_prefix)} rackup private_pub.ru" }
  set_default :private_pub_pid,       "#{fetch(:pids_path)}/private_pub.pid"
  set_default :private_pub_config,    "#{fetch(:config_path)}/private_pub.yml"
  set_default :private_pub_log,       "#{fetch(:logs_path)}/private_pub.log"

  set_default :rpush_name,            "rpush_#{fetch(:app_namespace!)}"
  set_default :rpush_cmd,             lambda { "#{fetch(:bundle_bin)} exec rpush" }
  set_default :rpush_upstart,         "#{fetch(:upstart_path!)}/#{fetch(:rpush_name)}.conf"
  set_default :rpush_start,           "#{fetch(:rpush_cmd)} start -f -e #{fetch(:rails_env)}"

  set_default :monit_config_path,     "/etc/monit/conf.d"
  set_default :monit_http_port,       2812
  set_default :monit_http_username,   "PleaseChangeMe_monit"
  set_default :monit_http_password,   "PleaseChangeMe"

  set_default :shared_paths,          %w(
                                        tmp
                                        log
                                        public/uploads
                                      )

  set_default :monitored,             %w(
                                        nginx
                                        postgresql
                                        redis
                                        puma
                                        sidekiq
                                        private_pub
                                        memcached
                                        )

  set_default :server_stack,          %w(
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
