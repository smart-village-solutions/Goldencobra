FROM ruby:2.2.2

RUN apt-get update -qq && apt-get install -y build-essential

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs


#setup ssh key
RUN mkdir -p /root/.ssh
ADD docker_config/id_* /root/.ssh/
RUN chmod -R 0644 /root/.ssh && chmod 0600 /root/.ssh/id_*
RUN echo "Host git.ikusei.de\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config



ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME