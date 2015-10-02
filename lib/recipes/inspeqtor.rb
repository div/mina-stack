namespace :inspeqtor do

  task(:install) {}

  task(:setup) {}

  [:"start deploy", :"finish deploy", :status].each do |command|
    desc "Inspeqtor #{command}"
    task command do
      queue  %[echo "-----> Inspeqtor #{command}."]
      queue "inspeqtorctl #{command}"
    end
  end
end
