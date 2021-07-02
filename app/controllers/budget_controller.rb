# frozen_string_literal: true
class BudgetController < ApplicationController
  def search_models
    price = params[:price].presence || %w[10000 20000 50000 100000].sample
    min = price.to_i * 0.9
    max = price.to_i * 1.2
    @grouped = AdsGroupedByMakerModelYear.by_budget(min, max)

    @meta_title = "Рекарио – Какой автомобиль купить до #{price} $ ?"
    @meta_description = "Список автомобилей в бюджете #{price} $"
    @meta_keywords = "Автомобиль за #{price} $"
    @meta_og_title = "Список моделей авто за #{price} $"
    @meta_og_description = "Что купить за #{price} $ ?"

    if request.path == "/budget/#{price}" || price.to_i.zero?
      render('/budget/search_models', layout: 'widgets')
    else
      redirect_to("/budget/#{price}")
    end
  end

  def show_model
    @models = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model', maker: params[:maker].downcase, model: params[:model].downcase)
    @models = @models.where.not(year: nil) # TODO: Defensive query
    raise ActiveRecord::RecordNotFound if @models.blank?

    @meta_title = "Рекарио – стоимость #{@models.first.maker} #{@models.first.model} по годам"
    @meta_description = "Средняя стоимость #{@models.first.maker} #{@models.first.model} разбитая по годам"
    @meta_keywords = @models.map { |m| "#{m.maker} #{m.model} #{m.year}" }.join(',')
    @meta_og_title = @meta_title
    @meta_og_description = @meta_description

    render('/budget/show_model', layout: 'widgets')
  end

  def show_model_year
    @model_year = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model AND year = :year', maker: params[:maker].downcase, model: params[:model].downcase, year: params[:year]).first
    raise ActiveRecord::RecordNotFound unless @model_year

    opts_types_ids = Hash[AdOptionType.where(name: %w[maker model year]).pluck(:name, :id)]
    opts_values_ids = Hash[AdOptionValue.where(value: [
      params[:maker],
      params[:model],
      params[:year],
    ]).pluck(:value, :id)]

    @ads = Ad.where(deleted: false).by_options('maker', opts_types_ids['maker'], opts_values_ids[params[:maker]])
    @ads = @ads.joins(:city)
    @ads = @ads.by_options('model', opts_types_ids['model'], opts_values_ids[params[:model]])
    @ads = @ads.by_options('year', opts_types_ids['year'], opts_values_ids[params[:year]])

    @ads_grouped_by_region = @ads.group(:city_id).count.sort_by(&:last).reverse
    cities = Hash[City.where(id: @ads_grouped_by_region.map(&:first)).joins(:region).pluck('cities.id, regions.name')]
    @ads_grouped_by_region = Hash[@ads_grouped_by_region].transform_keys { |city_id| cities[city_id] }.to_a

    @meta_title = "Рекарио – минимальная, средняя и максимальная стоимость #{@model_year.maker} #{@model_year.model} #{@model_year.year} года"
    @meta_description = "Все цены на #{@model_year.maker} #{@model_year.model} #{@model_year.year} года и количество объявлений по городам"
    @meta_keywords = "Цена #{@model_year.maker} #{@model_year.model} #{@model_year.year}, минимальная цена #{@model_year.maker} #{@model_year.model} #{@model_year.year}, средняя цена #{@model_year.maker} #{@model_year.model} #{@model_year.year}, сколько стоит #{@model_year.maker} #{@model_year.model} #{@model_year.year}"
    @meta_og_title = @meta_title
    @meta_og_description = @meta_description

    render('/budget/show_model_year', layout: 'widgets')
  end

  def show_ads
    @meta_title = "Рекарио – поиск объявлений о продаже и покупке авто через друзей и знакомых ?"
    @meta_description = "Покупка и продажа автомобилей в Украине через друзей и знакомых"
    @meta_keywords = "автомобили, машины, купить машину, продать машину, купить авто, продать авто"
    @meta_og_title = "Рекарио – покупка и продажа автомобилей в Украине через друзей и знакомых"
    @meta_og_description = "Покупка и продажа автомобилей в Украине через друзей и знакомых"

    render('/budget/show_ads', layout: 'widgets')
  end
end
