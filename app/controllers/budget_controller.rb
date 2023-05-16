# frozen_string_literal: true

class BudgetController < ApplicationController
  def search_models
    price = params[:price].presence || %w[10000 20000 50000 100000].sample
    min = price.to_i * 0.9
    max = price.to_i * 1.2
    @grouped = AdsGroupedByMakerModelYear.by_budget(min, max)

    @meta_title = "Рекаріо – Який авто купити до #{price} $ ?"
    @meta_description = "Список авто у бюджеті #{price} $"
    @meta_keywords = "Авто за #{price} $"
    @meta_og_title = "Список моделей авто за #{price} $"
    @meta_og_description = "Що купити за #{price} $ ?"

    if request.path == "/budget/#{price}" || price.to_i.zero?
      render("/budget/search_models", layout: "widgets")
    else
      redirect_to("/budget/#{price}")
    end
  end

  def show_model
    @models = AdsGroupedByMakerModelYear.where("LOWER(maker) = :maker AND LOWER(model) = :model", maker: params[:maker].downcase, model: params[:model].downcase)
    @models = @models.where.not(year: nil) # TODO: Defensive query
    raise ActiveRecord::RecordNotFound if @models.blank?

    @meta_title = "Рекаріо – вартісь #{@models.first.maker} #{@models.first.model} по рокам"
    @meta_description = "Середня вартість #{@models.first.maker} #{@models.first.model} по рокам"
    @meta_keywords = @models.map { |m| "#{m.maker} #{m.model} #{m.year}" }.join(",")
    @meta_og_title = @meta_title
    @meta_og_description = @meta_description

    render("/budget/show_model", layout: "widgets")
  end

  def show_model_year
    @model_year = AdsGroupedByMakerModelYear.where("LOWER(maker) = :maker AND LOWER(model) = :model AND year = :year", maker: params[:maker].downcase, model: params[:model].downcase, year: params[:year]).first
    raise ActiveRecord::RecordNotFound unless @model_year

    @ads = Ad.active.by_options("maker", params[:maker]).by_options("model", params[:model]).by_options("year", params[:year])

    @ads_grouped_by_region = @ads.group(:city_id).count.sort_by(&:last).reverse
    cities = City.where(id: @ads_grouped_by_region.map(&:first)).joins(:region).pluck("cities.id, regions.name").to_h
    @ads_grouped_by_region = @ads_grouped_by_region.to_h.transform_keys { |city_id| cities[city_id] }.to_a

    @meta_title = "Рекаріо – мінімальна, середня і максимальна вартість #{@model_year.maker} #{@model_year.model} #{@model_year.year} року"
    @meta_description = "Всі ціни на #{@model_year.maker} #{@model_year.model} #{@model_year.year} року та кількість оголошень по рокам"
    @meta_keywords = "Ціна #{@model_year.maker} #{@model_year.model} #{@model_year.year}, мінімальна ціна #{@model_year.maker} #{@model_year.model} #{@model_year.year}, середня ціна #{@model_year.maker} #{@model_year.model} #{@model_year.year}, сколько стоит #{@model_year.maker} #{@model_year.model} #{@model_year.year}"
    @meta_og_title = @meta_title
    @meta_og_description = @meta_description

    render("/budget/show_model_year", layout: "widgets")
  end

  def show_ads
    @meta_title = "Рекаріо – пошук оголошень про продаж чи покупку авто через друзів та знайомих"
    @meta_description = "Покупка і продаж авто в Україні через друзів та знайомих"
    @meta_keywords = "авто, машини, купити машину, продати машину, купити авто, продати авто"
    @meta_og_title = "Рекаріо – покупка та продаж авто в Україні через друзів та знайомих"
    @meta_og_description = "Покупка і продаж авто в Україні через друзів та знайомих"

    render("/budget/show_ads", layout: "widgets")
  end
end
