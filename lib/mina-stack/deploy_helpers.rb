module Mina
  module DeployHelpers
    def deploy_script(&blk)
      set_default :term_mode, :pretty
      code = isolate do
        yield
        erb Mina::Stack.root_path('data/deploy.sh.erb')
      end
    end
  end
end