require 'capistrano_colors'
require 'bundler/capistrano'

set :application, "defuze.me website"

# Repository
set :scm, :git
set :repository,  "git@github.com:defuzeme/server.git"

# Server
server "lambda.rootbox.fr", :app, :web, :db, :primary => true
set :user, :deploy
set :deploy_to, "/home/deploy/defuzeme"
set :use_sudo, false

# rbenv
set :default_environment, {
  'PATH' => "/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH"
}

# bundler
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

# unicorn commands
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run 'sudo start defuzeme'
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run 'sudo stop defuzeme'
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run 'sudo restart defuzeme'
  end
end

# custom symlink
namespace :config do
  task :symlinks, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:update_code", "config:symlinks"