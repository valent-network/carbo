# frozen_string_literal: true
class BudgetController < ApplicationController
  def search_models
    min = params[:price].to_i * 0.8
    max = params[:price].to_i * 1.2
    @grouped = AdsGroupedByMakerModelYear.by_budget(min, max)

    if request.path == "/budget/#{params[:price]}" || params[:price].to_i.zero?
      render('/budget/search_models', layout: 'widgets')
    else
      redirect_to("/budget/#{params[:price]}")
    end
  end

  def show_model
    @models = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model', maker: params[:maker].downcase, model: params[:model].downcase)
    render('/budget/show_model', layout: 'widgets')
  end

  def show_model_year
    @model_year = AdsGroupedByMakerModelYear.where('LOWER(maker) = :maker AND LOWER(model) = :model AND year = :year', maker: params[:maker].downcase, model: params[:model].downcase, year: params[:year]).first
    @ads = Ad.where("details->>'maker' = ? AND details->>'model' = ? AND details->>'year' = ?", params[:maker], params[:model], params[:year])
    render('/budget/show_model_year', layout: 'widgets')
  end
end
