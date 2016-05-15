module Middleman
  module Deploy
    module Strategies
      module Git
        class Push < Base
          def process
            Dir.chdir(self.build_dir) do
              clone_remote_url
              checkout_branch
              commit_branch
            end
          end

          private
          
          def clone_remote_url
            url = get_remote_url
            
            run_or_fail "git init"
            run_or_fail "git remote add origin #{url}"
            run_or_fail "git stash"
            run_or_fail "git pull origin #{self.branch}"
            run_or_fail "git stash pop"
            run_or_fail "git config user.name \"#{self.user_name}\""
            run_or_fail "git config user.name \"#{self.user_email}\""
          end

          def get_remote_url
            remote  = self.remote
            url     = remote

            # check if remote is not a git url
            unless remote =~ /\.git$/
              url = `git config --get remote.#{url}.url`.chop
            end

            # if the remote name doesn't exist in the main repo
            if url == ''
              puts "Can't deploy! Please add a remote with the name '#{remote}' to your repo."
              exit
            end

            url
          end
        end
      end
    end
  end
end
