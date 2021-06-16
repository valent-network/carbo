# frozen_string_literal: true
module ActiveAnalytics
  class Engine < ::Rails::Engine
    config.assets.precompile += %w(active_analytics_manifest.js active_analytics/application.js active_analytics/ariato.js)
  end
end
