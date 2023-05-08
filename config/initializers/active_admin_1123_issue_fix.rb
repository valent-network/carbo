# frozen_string_literal: true

module ActiveAdmin
  module Views
    class PaginatedCollection < ActiveAdmin::Component
      def build_pagination
        options = {theme: @display_total ? "active_admin" : "active_admin_countless"}
        options[:params] = @params if @params
        options[:param_name] = @param_name if @param_name

        unless @display_total
          # The #paginate method in kaminari will query the resource with a
          # count(*) to determine how many pages there should be unless
          # you pass in the :total_pages option. We issue a query to determine
          # if there is another page or not, but the limit/offset make this
          # query fast.
          # offset = collection.offset(collection.current_page * collection.limit_value).limit(1).count
          # Fixing https://github.com/activeadmin/activeadmin/issues/1123
          # Downside: we have empty page if none find, but it should work much
          # faster
          options[:total_pages] = collection.current_page + 1
          options[:right] = 0
        end

        text_node(paginate(collection, **options))
      end
    end
  end
end
