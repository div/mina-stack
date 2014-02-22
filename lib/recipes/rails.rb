# namespace :rails do

#   task(:install) {  }
#   task(:setup) {  }

#   task :log do
#     queue 'echo "Contents of the log file are as follows:"'
#     queue "tail -f #{logs_path}/#{rails_env}.log"
#   end
# end



# # desc "Open the rails console on one of the remote servers"
# #  task :console, :roles => :app do
# #    queue %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
# #  end

# #  desc "remote rake task"
# #  task :rake do
# #    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
# #  end