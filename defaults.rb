task :defaults do
  set_default :sockets_path,    "#{deploy_to}/#{shared_path}/tmp/sockets"
  set_default :pids_path,       "#{deploy_to}/#{shared_path}/tmp/pids"
  set_default :logs_path,       "#{deploy_to}/#{shared_path}/log"
  set_default :config_path,     "#{deploy_to}/#{shared_path}/config"

  set_default :term_mode,       :pretty
  set_default :shared_paths,    %w(
                                    tmp
                                    log
                                    config/puma.rb
                                    public/uploads
                                  )

  set_default :config_templates_path, "lib/mina/templates"

  set_default :puma_role, :app
  set_default :puma_config,  "#{config_path}/puma.rb"
  set_default :puma_pid,  "#{pids_path}/puma.pid"
  set_default :puma_log,  "#{logs_path}/puma.log"
  set_default :puma_socket,  "#{sockets_path}/puma.sock"
  set_default :puma_workers, 2

  set_default :nginx_config,    "#{nginx_path!}/sites-available/#{app!}_#{rails_env!}.conf"
  set_default :nginx_config_e,  "#{nginx_path!}/sites-enabled/#{app!}_#{rails_env!}.conf"

  set_default :psql_user,  "#{app!}"
  set_default :psql_database,  "#{app!}_#{rails_env}"

  set_default :sidekiq_cmd, lambda { "#{bundle_bin} exec sidekiq" }
  set_default :sidekiqctl_cmd, lambda { "#{bundle_prefix} sidekiqctl" }
  set_default :sidekiq_timeout, 10
  set_default :sidekiq_config, "#{config_path}/sidekiq.yml"
  set_default :sidekiq_log, "#{logs_path}/sidekiq.log"
  set_default :sidekiq_pid, "#{pids_path}/sidekiq.pid"
  set_default :sidekiq_concurrency, 10

  set_default :private_pub_cmd, lambda { "#{bundle_prefix} rackup private_pub.ru" }
  set_default :private_pub_pid, "#{pids_path}/private_pub.pid"
  set_default :private_pub_config, "#{config_path}/private_pub.yml"
  set_default :private_pub_log, "#{logs_path}/private_pub.log"
end