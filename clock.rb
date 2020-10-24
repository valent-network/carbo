# frozen_string_literal: true
require './config/boot'
require './config/environment'

module Clockwork
  every(1.day, 'Re-populate demo contacts') { DemoContactsPopulatorJob.perform_later }
end
