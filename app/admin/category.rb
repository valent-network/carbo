# frozen_string_literal: true

ActiveAdmin.register(Category) do
  menu label: proc { I18n.t('active_admin.category') }
  permit_params :name, :currency, translations: [:uk, :en]

  index do
    selectable_column
    column(:id)
    column(:name)
    column(:translations)
    column(:currency)
    column(:ad_option_types) do |category|
      "
      <span class='ad-option-types-sortable-list'>
        #{
          category.ad_option_types.order(:position).map do |aot|
            "<span class='filterable-node'>#{aot.name}</span>"
          end.join(' ')
        }
      </span>
      ".html_safe
    end
    actions
  end

  form do |f|
    f.input(:name)
    f.input(:currency, as: :select, include_blank: false, collection: Category::CURRENCIES)
    f.inputs(for: :translations) do |t|
      t.input(:uk, input_html: { value: f.object.translations['uk'] })
      t.input(:en, input_html: { value: f.object.translations['en'] })
    end
    f.actions
  end
end
