task :defaults do
  set_default :services_path,         "/etc/init.d"
  set_default :sockets_path,          "#{deploy_to}/#{shared_path}/tmp/sockets"
  set_default :pids_path,             "#{deploy_to}/#{shared_path}/tmp/pids"
  set_default :logs_path,             "#{deploy_to}/#{shared_path}/log"
  set_default :config_path,           "#{deploy_to}/#{shared_path}/config"

  set_default :term_mode,             :pretty
  set_default :shared_paths,          %w(
                                        tmp
                                        log
                                        public/uploads
                                      )

  set_default :config_templates_path, "lib/mina-ubuntu/templates"

  set_default :puma_name,             "puma_#{app!}_#{rails_env!}"
  set_default :puma_config,           "#{config_path}/puma.rb"
  set_default :puma_pid,              "#{pids_path}/puma.pid"
  set_default :puma_log,              "#{logs_path}/puma.log"
  set_default :puma_socket,           "#{sockets_path}/puma.sock"
  set_default :puma_workers,          2

  set_default :unicorn_name,          "unicorn_#{app!}_#{rails_env!}"
  set_default :unicorn_socket,        "#{sockets_path}/unicorn.sock"
  set_default :unicorn_pid,           "#{pids_path}/unicorn.pid"
  set_default :unicorn_config,        "#{config_path}/unicorn.rb"
  set_default :unicorn_log,           "#{logs_path}/unicorn.log"
  set_default :unicorn_error_log,     "#{logs_path}/unicorn.error.log"
  set_default :unicorn_script,        "#{services_path!}/#{unicorn_name}"
  set_default :unicorn_workers,       1
  set_default :unicorn_bin,           lambda { "#{bundle_bin} exec unicorn" }
  set_default :unicorn_user,          user
  set_default :unicorn_group,         user

  set_default :nginx_config,          "#{nginx_path!}/sites-available/#{app!}_#{rails_env!}.conf"
  set_default :nginx_config_e,        "#{nginx_path!}/sites-enabled/#{app!}_#{rails_env!}.conf"

  set_default :psql_user,             "#{app!}"
  set_default :psql_database,         "#{app!}_#{rails_env}"

  set_default :sidekiq_name,          "sidekiq_#{app!}_#{rails_env!}"
  set_default :sidekiq_cmd,           lambda { "#{bundle_bin} exec sidekiq" }
  set_default :sidekiqctl_cmd,        lambda { "#{bundle_prefix} sidekiqctl" }
  set_default :sidekiq_timeout,       10
  set_default :sidekiq_config,        "#{config_path}/sidekiq.yml"
  set_default :sidekiq_log,           "#{logs_path}/sidekiq.log"
  set_default :sidekiq_pid,           "#{pids_path}/sidekiq.pid"
  set_default :sidekiq_concurrency,   10

  set_default :private_pub_name,      "private_pub_#{app!}_#{rails_env!}"
  set_default :private_pub_cmd,       lambda { "#{bundle_prefix} rackup private_pub.ru" }
  set_default :private_pub_pid,       "#{pids_path}/private_pub.pid"
  set_default :private_pub_config,    "#{config_path}/private_pub.yml"
  set_default :private_pub_log,       "#{logs_path}/private_pub.log"

  set_default :monit_config_path,     "/etc/monit/conf.d"

  set_default :server_stack,          %w(
                                        nginx
                                        postgresql
                                        redis
                                        puma
                                        sidekiq
                                        private_pub
                                        monit
                                        bower
                                      )

  set_default :monitored,             %w(
                                          nginx
                                          postgresql
                                          redis
                                          puma
                                          sidekiq
                                          private_pub
                                        )
end