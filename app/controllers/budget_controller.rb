# frozen_string_literal: true
class BudgetController < ApplicationController
  def search_models
    price = params[:price].presence || %w[10000 20000 50000 100000].sample
    min = price.to_i * 0.9
    max = price.to_i * 1.2
    @grouped = AdsGroupedByMakerModelYear.by_budget(min, max)

    if request.path == "/budget/#{price}" || price.to_i.zero?
      render('/budget/search_models', layout: 'widgets')
    else
      redirect_to("/budget/#{price}")
    end
  end

  def show_model
    @models = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model', maker: params[:maker].downcase, model: params[:model].downcase)
    render('/budget/show_model', layout: 'widgets')
  end

  def show_model_year
    @model_year = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model AND year = :year', maker: params[:maker].downcase, model: params[:model].downcase, year: params[:year]).first
    raise ActiveRecord::RecordNotFound unless @model_year
    @ads = Ad.where("LOWER(details->>'maker') = ? AND LOWER(details->>'model') = ? AND details->>'year' = ?", params[:maker].downcase, params[:model].downcase, params[:year])
    @ads_grouped_by_region = @ads.group("details->'region'->>0").count.sort_by(&:last).reverse
    render('/budget/show_model_year', layout: 'widgets')
  end

  def show_ads
    render('/budget/show_ads', layout: 'widgets')
  end
end
