Setting up the app
==================

These instructions assume that you are using RVM, rbenv, or something else that is compatible with .ruby-version.

* `gem install bundler`
* `bundle install`
* Create `config/database.yml` (see `config/database.yml.example`)
* Create `config/config.yml` (see `config/config.yml.example`)
* `rake db:create`
* `rake db:schema:load`
* `rake db:migrate`

You can now run rails server and navigate to `/admin/users/` to manually add politicians. Alternatively, you can load politicians in bulk from a CSV spreadsheet using the `rake politicians:import_csv CSV=myfile.csv` command. See twoopsters.csv as an example of the format to use. If you use the `politicians:import_csv` task you should then use the `politicians:reset_avatars` task as well. This will download the avatars currently in use by each politician.


