FROM ruby:3.0.2-alpine

RUN apk update && apk --no-cache add build-base postgresql-dev tzdata git bash nodejs postgresql-client shared-mime-info

RUN mkdir -p /app/tmp/pids

COPY Gemfile* /gems/

ARG GIT_COMMIT
ENV GIT_COMMIT $GIT_COMMIT

WORKDIR /gems

RUN gem install bundler -v 2.2.31 && bundle install -j 8 --full-index --without development test

WORKDIR /app

COPY . /app

CMD bundle exec puma -C config/puma.rb
