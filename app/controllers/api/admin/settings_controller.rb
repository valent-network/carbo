module Api
  module Admin
    class SettingsController < AdminApiController
      def update
        # TODO: Temp implementation
        ActiveRecord::Base.transaction do
          params[:categories].each do |c|
            Category.where(id: c[:id]).update_all(position: c[:position])
            c[:ad_option_types].each do |o|
              AdOptionType.where(id: o[:id]).update_all(position: o[:position])
              o[:values].each do |v|
                FilterableValuesGroup.where(id: v[:id]).update_all(position: v[:position])
              end
            end
          end
        end
        CachedSettings.refresh
        head 200
      end
    end
  end
end
