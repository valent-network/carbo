# frozen_string_literal: true
require 'clockwork'
require 'active_support/time'
require 'redis'
require 'sidekiq'
require 'sidekiq/api'

require './config/initializers/sidekiq'

def enqueue(job_params)
  base_job_params = { 'args' => [], 'retry' => true, 'backtrace' => false, 'queue' => 'default' }
  job_params = base_job_params.merge(job_params)

  Sidekiq::Client.push(job_params)
end

module Clockwork
  every(1.day, 'Mark old ads as deleted', at: '05:00', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'MarkOldAdsAsDeleted') }

  every(1.day, 'Snapshot Dashboard Stats', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'SnapshotSystemStats') }

  every(1.hour, 'Delete Old VerificationRequests', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'DeleteOldVerificationRequests') }

  every(1.hour, 'Provider.crawl', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'AutoRia::IndexCrawler', 'queue' => 'provider', 'lock' => 'until_expired', 'lock_ttl' => 3600) }

  every(1.minute, 'Request Provider to Actualize Ads', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'ActualizeAd', 'queue' => 'ads', 'lock' => 'until_expired', 'lock_ttl' => 3600) }

  every(30.seconds, 'Snapshot User Visibility', skip_first_run: true, tz: 'UTC') { enqueue('class' => 'SnapshotUserVisibility') }
end
