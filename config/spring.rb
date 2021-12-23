# frozen_string_literal: true

%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  .env
  .env.development
  .env.test
].each { |path| Spring.watch(path) }
