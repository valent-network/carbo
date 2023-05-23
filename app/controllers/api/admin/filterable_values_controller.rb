# frozen_string_literal: true

module Api
  module Admin
    class FilterableValuesController < AdminApiController
      def index
        ad_option_type = AdOptionType.find(params[:ad_option_type_id])
        payload = {
          known_options: ad_option_type.known_options,
          filterable_values: ad_option_type.filterable_values.group_by(&:name).transform_values { |group| group.map { |fv| fv.as_json(only: %i[id raw_value name]) } }
        }

        render(json: payload)
      end

      def create
        ad_option_type = AdOptionType.find(params[:ad_option_type_id])
        raise "FilterableValuesGroup not found" unless ad_option_type.groups.find_by(name: params[:group_name])

        if params[:raw_value].in?(ad_option_type.known_options)
          filterable_value = ad_option_type.filterable_values.new(name: params[:group_name], raw_value: params[:raw_value])

          if filterable_value.save
            head(:created)
          else
            render(json: {errors: filterable_value.errors.full_messages}, status: :unprocessable_entity)
          end
        else
          error!("unknown_option")
        end
      end

      def update
        filterable_value = FilterableValue.find(params[:id])

        if filterable_value.update(name: params[:group_name])
          head(:ok)
        else
          render(json: {errors: filterable_value.errors.full_messages}, status: :unprocessable_entity)
        end
      end

      def destroy
        filterable_value = FilterableValue.find(params[:id])

        if filterable_value.destroy
          head(:ok)
        else
          render(json: {errors: filterable_value.errors.full_messages}, status: :unprocessable_entity)
        end
      end
    end
  end
end
