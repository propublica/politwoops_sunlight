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

ENV PHANTOMJS_VERSION 2.1.1

# Commands
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y vim git wget libfreetype6 libfontconfig bzip2 && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs

RUN apt-get install -y beanstalkd

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
CMD bin/run-collector-dockercmd
