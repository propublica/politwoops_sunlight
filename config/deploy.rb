set :application, "politwoops"
set :repository, "." 
set :scm, :none 
set :deploy_via, :copy
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "new.politwoops.nl"                          # Your HTTP server, Apache/etc
role :app, "new.politwoops.nl"                          # This may be the same as your `Web` server
role :db,  "new.politwoops.nl", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/home/breyten/politwoops"
set :use_sudo, false
set :keep_releases, 2

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end