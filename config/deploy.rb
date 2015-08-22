require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'

set :user, 'lightsaber'
set :domain, 'lightsaber.captnemo.in'
set :deploy_to, '/home/lightsaber/lightsaber'
set :repository, 'https://github.com/captn3m0/lightsaber.git'
set :branch, 'master'
set :identity_file, 'lightsaber-deploy'
set :rvm_path, "$HOME/.rvm/scripts/rvm"

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
# set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rvm:use[default]'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do

end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Don't try to decrypt it locally
    if ENV['CI'] === 'true'
      queue "openssl aes-256-cbc -K $encrypted_82a37ece568a_key -iv $encrypted_82a37ece568a_iv -in deploy-rsa -out lightsaber-deploy -d"
    end
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'

    to :launch do
      if File.exists?('thin.pid')
        queue "bundle exec thin -C config.yml restart"
      else
        queue "bundle exec thin -C config.yml start"
      end
    end
  end
end