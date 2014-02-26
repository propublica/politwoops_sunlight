# Setting up the app

* Create the databases in MySQL that you will need.
* Copy config/*.yml.sample and fill with the necessary values
  ```
  cp config/admin.yml.sample config/admin.yml
  ```
  ```
  cp config/database.yml.sample config/database.yml
  ```
  ```
  cp config/config.yml.sample config/config.yml
  ```
* Run ```bundle install``` to install all dependencies.
* Run ```rake db:setup```
* Run ```rake db:migrate```
* Run ```rake db:seed``` to load in a default group.

# Loading in data
* The project includes "politicos_uy.csv" which contains all the initial info to get twitter users
* Run ```rake politicians:import CSV="politicos_uy.csv"```
