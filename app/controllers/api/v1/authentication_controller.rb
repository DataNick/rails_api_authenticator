class Api::V1::AuthenticationController < ApplicationController
  include EncryptionHelper
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  # before_action :authenticate
  skip_before_action :authenticate

  def login
    username, password = params[:username], params[:password]
    password_digest = $redis_credentials.get(params[:username])
    if redis_search.nil?
      render json: { message: "Record not found", status: :not_found, code: 404 }, status: :not_found
    else
      user = User.new(username:username, password_digest: password_digest)
      if user.authenticate(password)
        encrypted_data = encrypt(username)
        cookies[:username] = encrypted_data
        cookies[:salt] = response
        render json: {message: 'Successfully logged in.'}, status: 200
      else
        render json: { message: "Bad credentials", status: :unauthorized, code: 401 }, status: :unauthorized
      end
    end
  end

#
#   "username": "Dan",
# "password_digest": "$2a$12$5il2V34yTJZtRDp5vf391epzChiWFqhgN6t6LXC9XOlb6kVmOkuiG",
# "password": "Pa33&w0rD"
# 6323819

  def logout
    cookies[:username] = ''
    cookies[:hash] = ''
    render json: {message: 'Successfully logged out.'}, status: 200
  end

end
