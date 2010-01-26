set :application, "fiwakela"
set :domain, 'fb.iwakela.com'
#user for ssh login
set :user, 'root'

default_run_options[:pty] = true
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :repository,  "git@github.com:ilake/fiwakela.git"
set :scm, "git"
set :git_account, 'ilake'
set :scm_passphrase, "plokmiju" #This is your custom users password

set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_to, "/var/rails/deploy"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

after 'deploy:symlink',  'fiwakela:extra_setting'

namespace :fiwakela do 
  task :extra_setting do
    %w(database facebooker).each do |setting|
      config = "#{latest_release}/config/#{setting}.yml.online"
      run "cp #{config} #{latest_release}/config/#{setting}.yml;"
    end

  end

  task :update do 
    deploy::update
  end

  task :rebuild_asset do
    run "cd #{latest_release} && rake asset:packager:build_all;"
  end

  task :chown do
    run "cd #{latest_release} && chown www-data #{latest_release}/config/environment.rb;"
  end

  task :start do 
    deploy::migrate
    #rebuild_asset
    chown
    restart
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :deploy_all do 
    update
    start
  end
end
