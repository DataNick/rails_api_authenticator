class Api::V1::AuthenticationController < ApplicationController
  include EncryptionHelper
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  skip_before_action :authenticate

  def login
    username, password = params[:username], params[:password]
    username = username.downcase
    password_digest = $redis_credentials.get(username)
    if password_digest.nil?
      render json: { message: "Record not found", status: :not_found, code: 404 }, status: :not_found
    else
      user = User.new(username:username, password_digest: password_digest)
      if user.authenticate(password)
        encrypted_data = encrypt(username)
        cookies[:username] = encrypted_data
        render json: {message: 'Successfully logged in.'}, status: 200
      else
        render json: { message: "Bad credentials", status: :unauthorized, code: 401 }, status: :unauthorized
      end
    end
  end

  def logout
    cookies[:username] = ''
    render json: {message: 'Successfully logged out.'}, status: 200
  end

end
