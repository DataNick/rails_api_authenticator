class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    username, password = params[:username], params[:password]
    username = username.downcase
    if username.nil? || password.nil?
      render json: {errors: "bad request", status_code: 400}, status: :bad_request
      return
    end
    user = User.new(user_params)
    user.username = username
    if user.save_to_redis_store
      render json: user.serializable_hash, status: 200
    else
     errors = User.find_by_username(username) ? user.errors.full_messages << "Username already taken" : user.errors.full_messages
     render json: { message: "Bad credentials.", errors: errors, status: :unauthorized, code: 401 }, status: :unauthorized
    end
  end

  def auth_verification
    render json: { message: "Authorization verified.", status: :ok, code: 200 }, status: :ok
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
