FROM ruby:2.2

RUN apt-get update --fix-missing

# application dependencies
RUN apt-get install -y libmysqlclient-dev libpq-dev libcurl4-openssl-dev nodejs
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

WORKDIR /web/
ADD Gemfile /web/
ADD Gemfile.lock /web/
ADD ./vendor/cache /web/vendor/cache
RUN bundle install --deployment --without development --jobs=2

ADD . /web/

ENV RAILS_ENV production

# if you need to run post-deploy rake tasks that bake or precompute something
# on the local filesystem, do it here
#CMD bundle exec rake do_the_post_deploy_things

EXPOSE 80
CMD bundle exec unicorn -c ./config/unicorn.conf.rb
