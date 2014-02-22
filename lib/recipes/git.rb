namespace :git do

  # ## Deploy tasks
  # These tasks are meant to be invoked inside deploy scripts, not invoked on
  # their own.

  # Each release is marked by a unique tag, generated with the current timestamp.  This should
  # not be changed, as the format is matched in the list of tags to find deploy tags.
  set_default :release_tag, lambda { Time.now.utc.strftime("%Y%m%d%H%M%S") }

  # If `release_tag` is changed, then `release_matcher` must be too, to a regular expression
  # that will match all generated release tags.  In general it's best to leave both unchanged.
  set_default :release_matcher, /\A[0-9]{14}\Z/

  # On tagging a release, a message is also recorded alongside the tag.  This message can contain
  # anything useful - its contents are not important for the recipe.
  set_default :release_message, lambda { "Deployed at #{Time.now}" }

  # Some tasks need to know the `latest_tag` - the most recent successful deployment.  If no
  # deployments have been made, this will be `nil`.
  set_default :latest_tag, lambda { latest_tag_from_repository }

  desc "Updates local repo from the Git repository."
  task :update_code do
    invoke :'git:fetch'
    invoke :'git:status'
    invoke :'git:tag'
  end

  desc "Fetches latest commits from the Git repository."
  task :fetch do
    queue %{
      if [ ! -d "#{deploy_path}/.git" ]; then
        echo "-----> Cloning the Git repository" &&
        #{echo_cmd %[git clone "#{repository!}" "#{deploy_path}"]} &&
        echo "-----> Using this email for git user #{user}@#{app}.git" &&
        #{echo_cmd %[cd #{deploy_path} && git config user.email #{user}@#{app}.git && git config user.name #{user}]}
      else
        echo "-----> Fetching new git commits" &&
        #{echo_cmd %[cd #{deploy_path} && git fetch && git reset --hard origin/#{branch}]}
      fi &&
      echo   "-----> Using git branch '#{branch}'" &&
      echo
    }
  end

  task :status do
    queue %{ echo "-----> Using this git commit" }
    git '--no-pager log --format="%aN (%h):%n> %s" -n 1]'
  end

  task :user do
    queue %{ echo "-----> Using this email #{user}@#{app}.git" }
    git "config user.email '#{user}@#{app}.git'"
    git "config user.name '#{user}'"
  end

  task :tag do
    unless release_tag =~ release_matcher
      error "The release_tag must be matched by the release_matcher regex, #{release_tag} doesn't match #{release_matcher}"
      exit
    end
    queue %{ echo "-----> Tagging release with #{release_tag}, #{release_message}" }
    git "tag #{release_tag} -m '#{release_message}'"
  end

  task :cleanup do
    queue %{ echo "-----> Removing this release tag #{release_tag}" }
    git "tag -d #{release_tag}"
    queue %{ echo "-----> Rolling back to #{latest_tag}" }
    git "reset --hard #{latest_tag}" if latest_tag
    invoke :'git:status'
  end

  task :rollback do
    if latest_tag
      queue %{ echo "-----> Removing this release tag #{latest_tag}" }
      git "tag -d #{latest_tag}"
      if previous_tag = latest_tag_from_repository(from_end: 2)
        queue %{ echo "-----> Rolling back to #{previous_tag}" }
        git "reset --hard #{previous_tag}"
      end
      invoke :'git:status'
    else
      error "This app is not currently deployed"
      exit
    end
  end

  def latest_tag_from_repository(from_end: 1)
    tags = capture_git(:tag).strip.split
    tags.grep(release_matcher).pop(from_end).first
  end

  def git(command)
    queue %[
      echo &&
      #{echo_cmd %[cd #{deploy_path} && git #{command}]} &&
      echo
    ]
  end

  def capture_git(command)
    capture %[cd #{deploy_path} && git #{command}]
  end

end