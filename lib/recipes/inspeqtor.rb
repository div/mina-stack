namespace :inspeqtor do

  task(:install) {}

  task(:setup) {}

  [:"start deploy", :"finish deploy", :status].each do |cmd|
    desc "Inspeqtor #{cmd}"
    task cmd do
      comment "Inspeqtor #{cmd}."
      command "inspeqtorctl #{cmd}"
    end
  end
end
