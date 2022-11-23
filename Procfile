web: ./bin/puma -C ./config/puma.rb
worker: bundle exec sidekiq -c 20  -q ads, 1 -q default, 10 -q sms, 100 -q system, 5 -q contacts 50
rpush: bundle exec rpush start -f
clock: bundle exec clockwork clock.rb
