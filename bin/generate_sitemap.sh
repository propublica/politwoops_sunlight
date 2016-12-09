#!/bin/bash

source $HOME/unicorn_environment.sh

cd /projects/twoops/www/current && bundle exec rake sitemap:refresh:no_ping > /dev/null
