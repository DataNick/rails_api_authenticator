class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :index]

  def index
    render json: {status: :ok, message: 'hello world'}
  end

  def create
    # create user, hash password, and save to redis store
  end

  def verify
  end
end
