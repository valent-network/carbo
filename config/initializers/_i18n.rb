# frozen_string_literal: true

I18n.load_path += Dir[Rails.root.join("config", "locales", "*.{rb,yml}").to_s]
I18n.reload!
