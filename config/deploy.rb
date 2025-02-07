require "bundler/capistrano"

set :application, "eris"
set :user, "eris"
set :deploy_to, "/home/eris/app"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@delta.library.yorku.ca:/home/git/repo/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases


# two stages
task :production do
  set :deploy_to, "/home/eris/app"
  set :bundle_cmd, "PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH bundle"

  set :default_environment, {
    'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  }
  server "hal.library.yorku.ca", :web, :app, :db, primary: true
end

task :demo do
  set :deploy_to, "/home/deployer/apps/#{application}.library.yorku.ca"
  set :bundle_cmd, "PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH bundle"

  set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  }

  server "demos.library.yorku.ca", :web, :app, :db, primary: true

  set :rails_env,      "demo"
end



namespace :deploy do
  %w[start stop restart].each do |command|
     desc "Restart #{application} passenger instance. All commands execute the same thing"
     task command, roles: :app, except: {no_release: true} do
        run "touch #{deploy_to}/current/tmp/restart.txt"
     end
   end

   task :setup_relative_ralis_root do
     set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT=\"/#{application}\""
   end
   before "deploy:assets:precompile", "deploy:setup_relative_ralis_root"

   task :setup_config, roles: :app do
     run "mkdir -p /webapps/apps/#{application}"
     run "ln -nfs #{current_path}/public /webapps/www-root/#{application}"
     run "cd /webapps/conf; ./add-conf.sh #{application}"
   end
   #before "deploy:setup", "deploy:setup_config"

end
