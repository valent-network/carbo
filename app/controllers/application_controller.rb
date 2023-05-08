# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false
  rescue_from StandardError, with: :standard_error
  around_action :switch_locale

  def filters
    # TODO: backward compat
    mobile_mappings = {fuel: :fuels, gear: :gears, carcass: :carcasses, wheels: :wheels}

    filters = CachedSettings.new.filters.select { |option_type, _| mobile_mappings[option_type.to_sym].present? }.map do |option_type, option_value_groups|
      [
        mobile_mappings[option_type.to_sym],
        option_value_groups.keys.map { |value_group| I18n.t("filters.types.#{option_type}.#{value_group}", default: value_group.to_s) }
      ]
    end.to_h

    render(json: filters.merge(hops_count: t("hops_count")))
  end

  protected

  attr_reader :current_user, :current_device, :current_ads_source

  def require_auth
    access_token = request.headers["X-User-Access-Token"] || params[:access_token]

    @current_device = UserDevice.includes(:user).find_by(access_token: access_token) if access_token.present?
    if @current_device
      @current_user = @current_device.user
      @current_device.update(locale: I18n.locale)
    end

    error!("NOT_AUTHORIZED", 401) unless current_user
  end

  def require_admin
    error!("NOT_AUTHORIZED", 401) unless current_user.admin?
  end

  def error!(message, status = 422, errors = {})
    Sentry.capture_message("Unknown error code: #{message}", level: :debug) unless message.in?(API_ERROR_CODES)
    payload = {message: t("api_error_messages.#{message.downcase}")}
    payload[:errors] = errors if errors.present?

    render(json: payload, status: status)
  end

  def standard_error(exception)
    raise exception if Rails.env.development? || Rails.env.test?

    Sentry.capture_exception(exception)
    render(json: {message: t("api_error_messages.unknown")}, status: 500)
  end

  def switch_locale(&action)
    locale = params[:locale] || request.headers["X-User-Locale"].to_s.scan(/^[a-z]{2}/).first.presence || "uk"
    locale = "uk" unless locale.in?(%w[en uk])

    I18n.with_locale(locale, &action)
  end

  def set_en_locale(&action)
    I18n.with_locale(:en, &action)
  end
end
