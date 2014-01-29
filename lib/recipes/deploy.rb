namespace :deploy do
  desc "Clean up."
  task :cleanup do
    if latest_tag
      queue %[ echo "-----> Deleting latest tag #{latest_tag}" ]
      git "tag -d #{latest_tag}"
      if previous_tag = latest_tag_from_repository
        queue %[ echo "-----> Reseting to previos tag #{previous_tag}" ]
        git "reset --hard #{previous_tag}"
      end
      invoke :restart
    else
      error "This app is not currently deployed"
      exit
    end
  end
end