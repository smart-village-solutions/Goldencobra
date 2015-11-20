FROM ruby:2.2.2

MAINTAINER ikusei GmbH

RUN apt-get update -qq && apt-get install -y build-essential

# install misc tools
RUN apt-get install -y curl wget git fontconfig make vim

# for nokogiri
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1
RUN apt-get install -y libxml2-dev libxslt1-dev libxml2

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs

RUN apt-get install git openssl

#setup ssh key
RUN mkdir -p /root/.ssh
ADD docker_config/id_* /root/.ssh/
RUN chmod -R 0644 /root/.ssh && chmod 0600 /root/.ssh/id_*
RUN echo "Host git.ikusei.de\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config



ENV APP_HOME /myapp
ENV DUMMY_APP /myapp/test/dummy
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
ADD goldencobra.gemspec $APP_HOME/
ADD . $APP_HOME


WORKDIR $DUMMY_APP

RUN bundle install

# http://blog.carbonfive.com/2015/03/17/docker-rails-docker-compose-together-in-your-development-workflow/
# https://docs.docker.com/mac/step_six/
# docker-machine rm default
# docker-machine create --driver virtualbox --virtualbox-cpu-count 2 --virtualbox-memory "4096" --virtualbox-disk-size "20000" default