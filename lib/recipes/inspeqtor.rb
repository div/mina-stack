namespace :inspeqtor do

  task(:install) {}

  task(:setup) {}

  [:"start deploy", :"finish deploy", :status].each do |command|
    desc "Inspeqtor #{command}"
    task command do
      queue "sudo inspeqtorctl #{command}"
      queue  %[echo "-----> Inspeqtor #{command}."]
    end
  end
end
