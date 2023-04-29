# frozen_string_literal: true
require 'clockwork'
require 'active_support/time'
require 'redis'
require 'sidekiq'
require 'sidekiq/api'

require './config/initializers/_redis'
require './config/initializers/sidekiq'

def enqueue(worker_class, job_params = {})
  base_job_params = { 'args' => [], 'retry' => true, 'backtrace' => false, 'queue' => 'default' }
  job_params = base_job_params.merge(job_params).merge('class' => worker_class)

  Sidekiq::Client.push(job_params)
end

module Clockwork
  every(1.day, 'Snapshot User Visibility', at: '03:00', skip_first_run: true, tz: 'UTC') { enqueue('SnapshotUserVisibility') }

  every(1.day, 'Mark old ads as deleted', at: '05:00', skip_first_run: true, tz: 'UTC') { enqueue('MarkOldAdsAsDeleted') }

  every(1.day, 'Snapshot Dashboard Stats', skip_first_run: true, tz: 'UTC') { enqueue('SnapshotSystemStats') }

  every(6.hours, 'Update User statistics', skip_first_run: true, tz: 'UTC') { enqueue('UpdateUserStats') }

  every(1.hour, 'Delete Old VerificationRequests', skip_first_run: true, tz: 'UTC') { enqueue('DeleteOldVerificationRequests') }

  every(1.hour, 'Update Ad statistics', skip_first_run: true, tz: 'UTC') { enqueue('UpdateAdStats') }

  every(1.hour, 'Delete Old Presigned Images', skip_first_run: true, tz: 'UTC') { enqueue('CleanupTempAdImage') }

  every(1.hour, 'Provider.crawl', skip_first_run: true, tz: 'UTC') { enqueue('AutoRia::IndexCrawler', 'queue' => 'provider', 'lock' => 'until_expired', 'lock_ttl' => 3600) }

  every(5.minutes, 'Refresh dashboard_stats mview', tz: 'UTC')

  every(1.minute, 'Request Provider to Actualize Ads', skip_first_run: true, tz: 'UTC') { enqueue('ActualizeAd', 'queue' => 'ads', 'lock' => 'until_expired', 'lock_ttl' => 3600) }

  # Postgres maintenance
  every(1.day, '[PG] ANALYZE', at: '02:00', tz: 'UTC', if: lambda { |t| t.wday.in?([1, 4]) }) { enqueue('PgAnalyze') }
  every(1.week, '[PG] ANALYZE', at: 'Thursday 02:00', tz: 'UTC') { enqueue('PgAnalyze') }
  every(1.week, '[PG] CLUSTER', at: 'Tuesday 02:00', tz: 'UTC') { enqueue('PgCluster') }
  every(1.week, '[PG] REINDEX DATABASE', at: 'Wednesday 02:00', tz: 'UTC') { enqueue('PgReindex') }

  # REFRESH MATERIALIZED VIEW CONCURRENCTLY
  every(5.minutes, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY dashboard_stats', tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['dashboard_stats']) }
  every(10.minutes, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY known_options', tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['known_options']) }
  every(1.hour, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY ads_grouped_by_maker_model_year', tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['ads_grouped_by_maker_model_year']) }
  every(1.hour, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY active_known_ads', at: '*:25', if: lambad { |t| t.hour.in?([6, 9, 12, 15, 18, 21]) }, tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['active_known_ads']) }
  every(1.hour, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY users_known_ads', at: '*:35', if: lambad { |t| t.hour.in?([6, 9, 12, 15, 18, 21]) }, tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['users_known_ads']) }
  every(1.hour, '[PG] RERFRESH MATERIALIZED VIEW CONCURRENCTLY users_known_users', at: '*:45', if: lambad { |t| t.hour.in?([6, 9, 12, 15, 18, 21]) }, tz: 'UTC', skip_first_run: true) { enqueue('PgRefreshMview', 'args' => ['users_known_users']) }
end
