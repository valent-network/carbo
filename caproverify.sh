#! /usr/bin/ruby
# frozen_string_literal: true

base_dockerfile = File.read('./Dockerfile')

File.read('./Procfile').split("\n").map { |l| l.split(':').map(&:strip) }.to_h.each do |process, cmd|
  File.open("caprover/#{process}/captain-definition", "w") do |f|
    f.puts <<~JSON
      {
        "schemaVersion": 2,
        "dockerfilePath": "./#{process}/Dockerfile"
      }
    JSON

    File.open("caprover/#{process}/Dockerfile", "w") do |f|
      f.puts(base_dockerfile.gsub(/^CMD.*$/, "CMD #{cmd}"))
    end
  end
end
