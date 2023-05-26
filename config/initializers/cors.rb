Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*ENV["CORS_ALLOWED_ORIGINS"].to_s.split(" "))
    resource "*", headers: :any, methods: [:get, :post, :patch, :put, :options, :head]
  end
end
