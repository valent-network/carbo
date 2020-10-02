# frozen_string_literal: true
namespace :ads do
  desc 'Export ads to CSV'
  task export: :environment do
    "COPY (SELECT phone_numbers.full_number AS phone_number,price,deleted,stale,ad_type,created_at,updated_at,details FROM ads JOIN phone_numbers ON ads.phone_number_id = phone_numbers.id LIMIT 1) TO '/Users/viktorvsk/ads.csv' DELIMITER ',' QUOTE '''' CSV HEADER;"
  end
end
