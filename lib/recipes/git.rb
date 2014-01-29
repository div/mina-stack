namespace :git do
  # ## Deploy tasks
  # These tasks are meant to be invoked inside deploy scripts, not invoked on
  # their own.

  # Each release is marked by a unique tag, generated with the current timestamp.  This should
  # not be changed, as the format is matched in the list of tags to find deploy tags.
  set_default(:release_tag) { Time.now.utc.strftime("%Y%m%d%H%M%S") }

  # If `release_tag` is changed, then `release_matcher` must be too, to a regular expression
  # that will match all generated release tags.  In general it's best to leave both unchanged.
  set_default(:release_matcher) { /\A[0-9]{14}\Z/ }

  # On tagging a release, a message is also recorded alongside the tag.  This message can contain
  # anything useful - its contents are not important for the recipe.
  set_default(:release_message, "Deployed at #{Time.now}")

  # Some tasks need to know the `latest_tag` - the most recent successful deployment.  If no
  # deployments have been made, this will be `nil`.
  set_default(:latest_tag) { latest_tag_from_repository }

  desc "Updates local repo from the Git repository."
  task :update_code do
    invoke :fetch
    invoke :status
    invoke :tag
  end


  desc "Fetches latest commits from the Git repository."
  task :fetch do
    queue %{
      if [ ! -d "#{deploy_to}/.git" ]; then
        echo "-----> Cloning the Git repository"
        #{echo_cmd %[git clone "#{repository!}" "#{deploy_to}" --bare]}
      else
        echo "-----> Fetching new git commits"
        #{echo_cmd %[(cd "#{deploy_path}" && git fetch && git reset --hard origin/#{branch}")]}
      fi &&
      echo "-----> Using git branch '#{branch}'" &&
    }
  end

  task :status do
    queue %[
      echo "-----> Using this git commit" &&
      echo &&
      #{echo_cmd %[git --no-pager log --format="%aN (%h):%n> %s" -n 1]} &&
      echo
    ]
  end

  task :tag do
    unless release_tag =~ release_matcher
      error "The release_tag must be matched by the release_matcher regex, #{release_tag} doesn't match #{release_matcher}"
      exit
    end
    git "tag #{release_tag} -m '#{release_message}'"
  end

  def git(command)
    queue %[cd #{deploy_path} && git #{command}]
  end

  def capture_git(command)
    capture %[cd #{deploy_path} && git #{command}]
  end

  def latest_tag_from_repository
    tags = capture_git("tag").strip.split
    tags.grep(release_matcher).last
  end

end