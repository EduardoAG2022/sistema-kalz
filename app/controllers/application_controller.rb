class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  allow_browser versions: :modern
end
