# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false
  rescue_from StandardError, with: :standard_error
  around_action :switch_locale

  def landing
    @total_count = EffectiveAd.count
    render('/landing', layout: false)
  end

  def filters
    mapping = {
      fuel: :fuels,
      gear: :gears,
      carcass: :carcasses,
      wheels: :wheels,
    }
    filters = FilterableValueTranslation.where(locale: I18n.locale).includes(:ad_option_type).pluck("ad_option_types.name, filterable_value_translations.name")
      .group_by(&:first)
      .transform_values { |v| v.map(&:last) }
      .transform_keys { |k| mapping[k.to_sym] }
      .merge(hops_count: t('hops_count'))

    render(json: filters)
  end

  def multibutton
    render('/multibutton', layout: false)
  end

  def static_page
    @page = StaticPage.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless @page

    @meta_title = JSON.parse(@page.meta)['title']
  end

  protected

  attr_reader :current_user, :current_device, :current_ads_source

  def require_auth
    access_token = request.headers['X-User-Access-Token'] || params[:access_token]

    @current_device = UserDevice.find_by(access_token: access_token) if access_token.present?
    if @current_device
      @current_user = @current_device.user
      @current_device.update(locale: I18n.locale)
    end

    error!('NOT_AUTHORIZED', 401) unless current_user
  end

  def error!(message, status = 422)
    Rails.logger.debug("Unknown error code: #{message}") unless message.in?(API_ERROR_CODES)
    render(json: { message: t("api_error_messages.#{message.downcase}") }, status: status)
  end

  def standard_error(exception)
    raise exception if Rails.env.development? || Rails.env.test?

    Rails.logger.error(exception)
    render(json: { message: t("api_error_messages.unknown") }, status: 500)
  end

  def switch_locale(&action)
    locale = params[:locale] || request.headers['X-User-Locale'].to_s.scan(/^[a-z]{2}/).first.presence || 'uk'
    locale = 'uk' unless locale.in?(%w[en uk])

    I18n.with_locale(locale, &action)
  end

  def set_en_locale(&action)
    I18n.with_locale(:en, &action)
  end
end
