# frozen_string_literal: true
class AdPricesPresenter
  def call(ad)
    versions = ad.versions.where.not(object: nil).order(:created_at).map(&:as_json).map do |ver|
      created_at = Date.parse(ver['created_at']).strftime('%F')
      price = ver['object'].scan(/\nprice: (\d+)\n/).first.first.to_i

      [created_at, price]
    end

    prices_history = versions.select { |v| v.last.present? }.uniq(&:last).reverse

    # TODO: Workaround to avoid cases when last history price equals to
    # current price. Need check against different cases, whether it brakes
    # anything else
    prices_history.shift if prices_history.present? && prices_history.first[1] == ad.price
    prices_history.pop if prices_history.present? && prices_history.last[1] == ad.price

    prices_history
  end
end
