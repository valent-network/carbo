# frozen_string_literal: true
class AddIndexForBetterShowModelYearBudgetWidgetSearch < ActiveRecord::Migration[6.1]
  def up
    ids = execute("SELECT id FROM ad_option_types WHERE name IN ('maker', 'model', 'year')").to_a.map { |x| x['id'] }
    add_index(:ad_options, :ad_option_value_id, where: "ad_option_type_id IN (#{ids.join(',')})")
  end

  def down
    remove_index(:ad_options, :ad_option_value_id)
  end
end
