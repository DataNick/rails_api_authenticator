class ApplicationController < ActionController::API
  include EncryptionHelper
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::Cookies
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  before_action :authenticate

  private

  def authenticate
    authenticate_user || handle_bad_authentication
  end

  def authenticate_user
    # using username but should be built out to substitute with a JWT or Auth token
    username = !cookies[:username].blank? ? decrypt(cookies[:username]) : ''
    response = $redis_credentials.get(username)
    if !response.nil?
      return true
    else
      return false
    end
  end

  def handle_bad_authentication
    render json: { message: "Bad credentials", status: :unauthorized, code: 401 }, status: :unauthorized
  end

  def handle_not_found
    render json: { message: "Record not found", status: :not_found, code: 404 }, status: :not_found
  end

end
