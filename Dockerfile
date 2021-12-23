FROM ruby:3.0.3-alpine AS base

ENV BUILD_PACKAGES="build-base postgresql-dev shared-mime-info"
ENV DEV_PACKAGES="tzdata postgresql-client git nodejs"
ENV EFFECTIVE_PACKAGES="bash"

ENV BUNDLER_VERSION="2.2.32"

ARG BUNDLE_CONFIG_WITHOUT="development test"

ARG GIT_COMMIT
ENV GIT_COMMIT $COMMIT_HASH

RUN apk --update --upgrade add $DEV_PACKAGES $EFFECTIVE_PACKAGES && \
  apk --update add --virtual build-deps $BUILD_PACKAGES && \
  gem update --system && \
  gem uninstall bundler --all && \
  gem install bundler:$BUNDLER_VERSION && \
  bundle config set without "$BUNDLE_CONFIG_WITHOUT" && \
  rm -rf /var/cache/apk/*

WORKDIR /gems
COPY ["Gemfile", "Gemfile.lock", "/gems/"]

RUN echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle install -j 8 --full-index --no-cache && \
  rm -rf ~/.gem && \
  apk del build-deps && \
  rm -rf /gems

WORKDIR /app

FROM base AS prod
COPY [".", "/app"]
RUN mkdir -p /app/tmp/pids

CMD bundle exec puma -C config/puma.rb
