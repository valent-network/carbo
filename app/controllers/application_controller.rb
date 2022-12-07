# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false
  rescue_from StandardError, with: :standard_error

  def landing
    @total_count = EffectiveAd.count
    render('/landing', layout: false)
  end

  def filters
    render(json: UserFriendlyAdsQuery::FILTERS)
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
    @current_user = @current_device.user if @current_device

    error!('NOT_AUTHORIZED', 401) unless current_user
  end

  def error!(message, status = 422)
    Rails.logger.debug("Unknown error code: #{message}") unless message.in?(API_ERROR_CODES)
    render(json: { message: t("api_error_messages.#{message.downcase}") }, status: status)
  end

  def standard_error(exception)
    raise exception if Rails.env.development?

    Rails.logger.error(exception)
    render(json: { message: t("api_error_messages.unknown") }, status: 500)
  end

  def set_en_locale(&action)
    I18n.with_locale(:en, &action)
  end
end
