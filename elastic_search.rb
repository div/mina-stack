namespace :es do

  desc "Install the latest release of ElasticSearch"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing ElasticSearch..."}
    queue "sudo apt-get install openjdk-7-jre -y"
    queue "wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.1.tar.gz -O elasticsearch.tar.gz"
    queue "tar -xf elasticsearch.tar.gz"
    queue "rm elasticsearch.tar.gz"
    queue "sudo mv elasticsearch-* elasticsearch"
    queue "sudo mv elasticsearch /usr/local/share"

    queue "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz"
    queue "mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/"
    queue "rm -Rf *servicewrapper*"
    queue "sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install"
    queue "sudo ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch"
  end

  %w[start stop restart].each do |command|
    desc "#{command} elasticsearch"
    task command do
      invoke :sudo
      queue "sudo service elasticsearch #{command}"
    end
  end

end