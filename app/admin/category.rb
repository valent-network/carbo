# frozen_string_literal: true

ActiveAdmin.register(Category) do
  menu priority: 13, label: proc { I18n.t("active_admin.category") }, parent: "settings"
  permit_params :name, :currency, :position, translations: [:uk, :en]

  index do
    selectable_column
    column(:id)
    column(:name)
    column(:translations)
    column(:currency)
    column(:ad_option_types) do |category|
      "
      <span class='ad-option-types-sortable-list' data-category-id='#{category.id}'>
        #{
          category.ad_option_types.order(:position).map do |aot|
            "<span class='filterable-node'>#{aot.name}</span>"
          end.join(" ")
        }
      </span>
      ".html_safe
    end
    column :position
    actions
  end

  form do |f|
    f.input(:name)
    f.input(:currency, as: :select, include_blank: false, collection: Category::CURRENCIES)
    f.inputs(for: :translations) do |t|
      t.input(:uk, input_html: {value: f.object.translations["uk"]})
      t.input(:en, input_html: {value: f.object.translations["en"]})
    end
    f.input(:position)
    f.actions
  end
end
