# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :access_token, :images_json_array_tmp, :apn_key, :authenticity_token, :apn_key_id, :team_id, :auth_key]
