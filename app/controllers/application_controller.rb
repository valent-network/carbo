# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false
  rescue_from StandardError, with: :standard_error
  around_action :switch_locale

  def landing
    @total_count = Ad.known.active.distinct('ads.id').count
    render('/landing', layout: false)
  end

  def filters
    render(json: FilterableValue.filters.merge(hops_count: t('hops_count')))
  end

  def cities
    cities_grouped_by_region = City.includes(:region).group_by(&:region)
    regions_sorted = AlphabetSort.call(cities_grouped_by_region.keys.map { |x| x.translations[I18n.locale.to_s] }, I18n.locale)
    cities_sorted = AlphabetSort.call(cities_grouped_by_region.values.flatten.map { |city| city.translations[I18n.locale.to_s] }, I18n.locale)

    payload = cities_grouped_by_region
      .sort_by { |k, _v| regions_sorted.index(k.translations[I18n.locale.to_s]) }
      .to_h
      .transform_keys { |region| region.translations[I18n.locale.to_s] }
      .transform_values do |cities|
        cities.sort_by { |city| cities_sorted.index(city.translations[I18n.locale.to_s]) }.map { |city| {name: city.translations[I18n.locale.to_s], id: city.id} }
      end

    render(json: payload)
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

    @current_device = UserDevice.includes(:user).find_by(access_token: access_token) if access_token.present?
    if @current_device
      @current_user = @current_device.user
      @current_device.update(locale: I18n.locale)
    end

    error!('NOT_AUTHORIZED', 401) unless current_user
  end

  def error!(message, status = 422, errors = {})
    Rails.logger.debug("Unknown error code: #{message}") unless message.in?(API_ERROR_CODES)
    payload = { message: t("api_error_messages.#{message.downcase}") }
    payload[:errors] = errors if errors.present?

    render(json: payload, status: status)
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
