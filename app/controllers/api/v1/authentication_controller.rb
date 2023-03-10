class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  # POST /api/v1/auth/login
  def login
    #find user from redis store
    # check if user is authenticated
    #if authenticated, set token and time expiration
    # render json with token, expiration, username and status ok
    # if not authenticated, return unauthorized error with status unauthorized
  end

end
