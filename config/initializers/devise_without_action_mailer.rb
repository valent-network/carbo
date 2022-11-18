# frozen_string_literal: true
if Rails.autoloaders.zeitwerk_enabled?
  module Devise
    class Mailer
    end
  end
end
