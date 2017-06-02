namespace :logs do

  desc "Shows available logs"
  task :list do
    comment "Available logs"
    command "ls #{fetch(:logs_path)}"
  end

  desc "Tails log"
  rule /logs:\w*/ do |t|
    log = t.name.split(":", 2)
    log_name = log[1]
    command "tail -f #{fetch(:logs_path)}/#{log_name}.log"
  end

end
