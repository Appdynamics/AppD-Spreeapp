FROM ruby:2.7.0
#
# Maintainer David Ryder
#
# Reference: https://docs.docker.com/compose/rails/

ARG USER
ARG HOME_DIR
ENV HOME_DIR="/"

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq   &&  \
    apt-get upgrade -yqq  &&  \
    apt-get install -yqq  zip vim curl tzdata \
    nodejs npm yarn \
    uuid-runtime && \
    apt-get -y clean

WORKDIR /myapp
COPY ctl.sh /myapp
COPY envvars.sh /myapp
COPY ruby1-config/Gemfile /myapp/Gemfile
COPY ruby1-config/Gemfile.lock /myapp/Gemfile.lock
RUN bundle update && bundle install

RUN rails new a1
COPY spreeapp-config/appdynamics.yml /myapp/a1/config
COPY ruby1-config/application.rb /myapp/a1/config
RUN echo "\n\n# AppDynamics\ngem 'appdynamics'" >> /myapp/a1/Gemfile
RUN cd /myapp/a1 && bundle update && bundle install

ENTRYPOINT /myapp/ctl.sh hold
