# frozen_string_literal: true
require './config/boot'
require './config/environment'

module Clockwork
  every(1.day, 'Vacuum Postgresql', at: '05:00', tz: 'UTC') { VacuumDatabase.perform_later }
  every(1.hour, 'Refresh Budget Widget Materialized View') { BudgetWidgetRefreshMaterializedView.perform_later }
  every(1.day, 'Backup Database', at: '03:00', tz: 'UTC') { BackupDatabase.perfrom_later }
end
