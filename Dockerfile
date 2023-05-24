FROM ruby:3.2.2-alpine AS Builder

ENV BUILD_PACKAGES="build-base postgresql-dev shared-mime-info"

ENV BUNDLER_VERSION="2.4.13"

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

FROM ruby:3.2.2-alpine

ENV EFFECTIVE_PACKAGES="bash tzdata postgresql-client imagemagick"

RUN apk add --no-cache $EFFECTIVE_PACKAGES

ARG CAPROVER_GIT_COMMIT_SHA=${CAPROVER_GIT_COMMIT_SHA}
ENV GIT_COMMIT=${CAPROVER_GIT_COMMIT_SHA}

WORKDIR /app

# Add user
RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app


EXPOSE 3000

RUN mkdir -p /app/tmp/pids

CMD bundle exec puma -C config/puma.rb
