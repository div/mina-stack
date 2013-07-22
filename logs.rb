task :log do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f #{logs_path}/#{rails_env}.log"
end