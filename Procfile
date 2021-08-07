web: bundle exec rails server
worker: bundle exec sidekiq -q default, 10 -q contacts, 100 -q sms, 1000 -q notifications, 1 -q system, 1 -q refresh-matviews, 50 -q provider-ads-delete, 10 -q promo, 1 -q provider-actualize, 20 -q provider-ads-new, 10 -q analytics, 1
rpush: bundle exec rpush start -f
