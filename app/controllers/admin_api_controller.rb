class AdminApiController < ApplicationController
  before_action :require_auth, :require_admin
end
