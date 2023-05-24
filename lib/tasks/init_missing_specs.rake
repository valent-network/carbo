# frozen_string_literal: true

desc "Create missing specs for existing classes [WIP]"
task init_missing_specs: :environment do
  files = Dir.glob(Rails.root.join("app/**/*.rb"))
  specs = Dir.glob(Rails.root.join("spec/**/*.rb"))

  to_create = files.map { |f| f.gsub(/\/app\//, "/spec/").gsub(/\.rb$/, "_spec.rb") } - specs

  require "pathname"

  to_create.map do |path|
    # TODO: Nested directories (i.e. models/concerns) are not supported
    class_name = path[Rails.root.join("spec").to_s.size + 1..].gsub(/(_spec\.rb$)/, "").split("/")[1..].map(&:camelize).join("::")

    path = Pathname(path)
    path.dirname.mkdir unless File.exist?(path.dirname)
    path.write(<<~RSPEC)
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe(#{class_name}) do
      end
    RSPEC
  end
end
