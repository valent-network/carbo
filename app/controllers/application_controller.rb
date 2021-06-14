# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false

  def landing
    @total_count = EffectiveAd.count
    render('/landing', layout: false)
  end

  def filters
    payload = {
      fuels: ['Газ', 'Газ / Бензин', 'Бензин', 'Гибрид', 'Дизель', 'Электро'],
      wheels: ['Передний', 'Задний', 'Полный'],
      carcasses: ['Хэтчбек', 'Купе', 'Универсал', 'Седан', 'Пикап', 'Внедорожник / Кроссовер', 'Лифтбек', 'Кабриолет', 'Родстер', 'Минивэн'],
      gears: ['Автомат', 'Ручная / Механика', 'Робот', 'Вариатор', 'Типтроник'],
    }
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

  def require_provider
    token = request.headers['Authorization'].gsub(/^Bearer /, '')
    return error!('NOT_AUTHORIZED', 401) if request.headers['Authorization'].blank?
    @current_ads_source = AdsSource.find_by(api_token: token)
    return error!('NOT_AUTHORIZED', 401) unless @current_ads_source
  end

  def require_auth
    # TODO: Fix [object Object] and "undefined"
    access_token = request.headers['X-User-Access-Token'] || params[:access_token]

    @current_device = UserDevice.find_by(access_token: access_token) if access_token.present?
    @current_user = @current_device.user if @current_device

    error!('NOT_AUTHORIZED', 401) unless current_user
  end

  def error!(message, status = 422)
    Rails.logger.debug("Unknown error code: #{message}") unless message.in?(API_ERROR_CODES)
    render(json: { message: t("api_error_messages.#{message.downcase}") }, status: status)
  end
end
