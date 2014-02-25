= Setting up the app

* Create the databases in MySQL that you will need.
* Run "bundle install" to install all dependencies.
* Run ```rake db:setup```
* Run ```rake db:migrate```
* Run ```rake db:seed``` to load in a default group.

= Loading in data
* The project includes "politicos_uy.csv" which contains all the initial info to get twitter users
* Run ```rake politicians:import CSV="politicos_uy.csv"```
