namespace :es do

  desc "Install the latest release of ElasticSearch"
  task :install do
    invoke :sudo
   command %{echo "-----> Installing ElasticSearch..."}
    command "sudo apt-get install openjdk-7-jre -y"
    command "wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.1.tar.gz -O elasticsearch.tar.gz"
    command "tar -xf elasticsearch.tar.gz"
    command "rm elasticsearch.tar.gz"
    command "sudo mv elasticsearch-* elasticsearch"
    command "sudo mv elasticsearch /usr/local/share"

    command "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz"
    command "mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/"
    command "rm -Rf *servicewrapper*"
    command "sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install"
    command "sudo ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch"
  end

  task(:setup) {  }

  %w[start stop restart].each do |cmd|
    desc "#{cmd} elasticsearch"
    task cmd do
      invoke :sudo
      command "sudo service elasticsearch #{cmd}"
    end
  end

end