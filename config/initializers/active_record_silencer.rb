# frozen_string_literal: true
ActiveRecord::Base.logger = nil if ENV['SILENCE_SQL'].present? && Rails.env.development?
