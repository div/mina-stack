require 'erb'
require 'shellwords'

def template(from, to=nil)
  comment "Putting #{from} file to #{to}"
  to ||= "#{config_path}/#{from.chomp(".erb")}"
  erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def put(content, file)
  queue %[echo #{escape content} > "#{file}"]
end

def escape(str)
  Shellwords.escape(str)
end

def check_symlink(destination)
  %{if [[ -h "#{destination}" ]]; #{check_response}}
end

def check_response
  'then echo "----->   SUCCESS"; else echo "----->   FAILED"; fi'
end


task :sudo do
  set :sudo, true
  set :term_mode, :system # :pretty doesn't seem to work with sudo well
end
