set :bundle_bin, 'bundle'

set :bundler_path, lambda { "#{deploy_path!}/vendor/gems" }

set :bundle_options, lambda { %{--without development test --path "#{bundler_path}" --binstubs --deployment --quiet} }

namespace :ms do
  namespace :bundle do
    # ### bundle:install
    # Installs gems.
    desc "Install gem dependencies using Bundler."
    task :install do
      queue %{
        echo "-----> Installing gem dependencies using Bundler"
        #{echo_cmd %[cd #{deploy_path}]}
        #{echo_cmd %[mkdir -p "#{bundler_path}"]}
        #{echo_cmd %[#{bundle_bin} install #{bundle_options}]}
      }
    end
  end
end