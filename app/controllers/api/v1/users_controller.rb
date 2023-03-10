class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :index]

  def create
    if params[:username].nil? || params[:password].nil?
      render json: {errors: "bad request", status_code: 400}, status: :bad_request
      return
    end
    # username, password = params[:username], params[:password]
    user = User.new(user_params)
    if user.save_to_redis_store
      render json: user.serializable_hash, status: 200
    else
     render json: { message: "Bad credentials", status: :unauthorized, code: 401 }, status: :unauthorized
    end
  end

  def verify
    render json: { message: "Welcome.", status: :ok, code: 200 }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
