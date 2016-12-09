#!/bin/bash

export PATH=/projects/twoops/.gem/ruby/1.8/bin:$PATH
export GEM_HOME=/projects/twoops/.gem/ruby/1.8

source $HOME/unicorn_environment.sh

cd /projects/twoops/www/current && bundle exec rake politicians:reset_avatars where_blank=1
