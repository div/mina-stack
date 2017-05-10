namespace :rails do

  task(:install) {  }
  task(:setup) {  }

  
end

namespace :rails do
  
  task :log do
    queue 'echo "Contents of the log file are as follows:"'
    queue "tail -f #{logs_path}/#{rails_env}.log"
  end
  
  desc 'Migrate database'
  task :db_migrate do
    if fetch(:force_migrate)
      comment %{Migrating database}
      command %{#{fetch(:rake)} db:migrate}
    else
      command check_for_changes_script(
        at: fetch(:migration_dirs),
        skip: %{echo "-----> DB migrations unchanged; skipping DB migration"},
        changed: %{echo "-----> Migrating database"
          #{echo_cmd("#{fetch(:rake)} db:migrate")}}
      ), quiet: true
    end
  end
  
  
  desc 'Migrate database'
  task :db_schema_load do
    comment %{Loading Schema}
    command %{#{fetch(:rake)} db:schema:load}
  end

  desc 'Create database'
  task :db_create do
    comment %{Creating database}
    command %{#{fetch(:rake)} db:create}
  end

  desc 'Rollback database'
  task :db_rollback do
    comment %{Rollbacking database}
    command %{#{fetch(:rake)} db:rollback}
  end

  desc 'Precompiles assets (skips if nothing has changed since the last release).'
  task :assets_precompile do
    if fetch(:force_asset_precompile)
      comment %{Precompiling asset files}
      command %{#{fetch(:rake)} assets:precompile}
    else
      command check_for_changes_script(
        at: fetch(:asset_dirs),
        skip: %{echo "-----> Skipping asset precompilation"},
        changed: %{echo "-----> Precompiling asset files"
          #{echo_cmd "#{fetch(:rake)} assets:precompile"}}
      ), quiet: true
    end
  end
end



# desc "Open the rails console on one of the remote servers"
#  task :console, :roles => :app do
#    queue %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
#  end

#  desc "remote rake task"
#  task :rake do
#    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
#  end
