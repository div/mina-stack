namespace :inspeqtor do

  task :install {}

  task :setup {}

  %w[start_deploy finish_deploy status].each do |command|
    desc "Inspeqtor #{command}"
    task command do
      queue "sudo inspeqtorctl #{command}"
      queue  %[echo "-----> Inspeqtor #{command}."]
    end
  end
end
