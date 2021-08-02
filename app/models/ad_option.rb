# frozen_string_literal: true
class AdOption < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :ad
  belongs_to :ad_option_type
  belongs_to :ad_option_value

  validates :ad_id, uniqueness: { scope: [:ad_option_type] }

  def self.titles_for(ads_ids)
    eager_load(:ad_option_type, :ad_option_value)
      .where(ad_id: ads_ids)
      .where("ad_options.ad_option_type_id IN (SELECT id FROM ad_option_types WHERE name IN ('maker', 'model', 'year'))")
      .each_with_object({}) do |ad_option, hsh|
        (hsh[ad_option.ad_id] ||= {})[ad_option.ad_option_type.name] = ad_option.ad_option_value.value
      end.transform_values do |opts|
        [opts['maker'], opts['model'], opts['year']].join(' ')
      end
  end
end
