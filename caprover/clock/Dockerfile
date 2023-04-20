FROM ruby:3.2.0-alpine AS Builder

ENV BUILD_PACKAGES="build-base postgresql-dev shared-mime-info git nodejs"

ENV BUNDLER_VERSION="2.4.3"

RUN apk add --no-cache $BUILD_PACKAGES && \
  gem install bundler:$BUNDLER_VERSION && \
  rm -rf /var/cache/apk/*

WORKDIR /app

ADD Gemfile* /app/

RUN  bundle config --local without "development test" && \
     bundle install -j8 --no-cache && \
     bundle clean --force && \
     rm -rf /usr/local/bundle/cache && \
     find /usr/local/bundle/gems/ -name "*.c" -delete && \
     find /usr/local/bundle/gems/ -name "*.o" -delete

ADD . /app

RUN rm -rf node_modules tmp/cache vendor/assets lib/assets spec

FROM ruby:3.2.0-alpine

ENV EFFECTIVE_PACKAGES="bash tzdata postgresql-client imagemagick"

RUN apk add --no-cache $EFFECTIVE_PACKAGES

ARG GIT_COMMIT
ENV GIT_COMMIT $COMMIT_HASH

WORKDIR /app

# Add user
RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app


EXPOSE 3000

RUN mkdir -p /app/tmp/pids

CMD bundle exec clockwork clock.rb
