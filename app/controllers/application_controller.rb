class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :authenticate

  private

  # def authenticate
  #   authenticate_user_with_token || handle_bad_authentication
  # end

  def authenticate
    authenticate_user || handle_bad_authentication
  end

  def authenticate_user_with_token
    authenticate_with_http_token do |token, options|
      @user ||= User.find_by(private_api_key: token)
    end
  end

  def authenticate_user
     # @user ||= User.find_by(private_api_key: token)
     # grab user with username and password, dehash password to confirm correct credentials

  end

  def handle_bad_authentication
    render json: { message: "Bad credentials", status: :unauhorized, code: 401 }, status: :unauthorized
  end

  def handle_not_found
    render json: { message: "Record not found", status: :not_found, code: 404 }, status: :not_found
  end

end
