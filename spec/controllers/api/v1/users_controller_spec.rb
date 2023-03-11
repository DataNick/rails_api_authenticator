require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include EncryptionHelper
  describe 'user#create' do
    it 'create returns http success' do
      if $redis_credentials.get('testuser')
        $redis_credentials.del('testuser')
      end
      post :create, as: :json, params: {username: 'TestUser', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:success)
    end

    it 'ensures only unique usernames can be stored in datastore' do
      post :create, as: :json, params: {username: 'TestUser', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'ensures passwords are in a valid format when signing up' do
      post :create, as: :json, params: {username: 'TestUser', password: 'pa33w0rd'}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'create returns 400 if credentials are not passed' do
      post :create, as: :json, params: {username: '', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'user#auth_verification' do
    it 'returns 200 status if user is authenticated' do
      cookies[:username] = encrypt('testuser')
      get :auth_verification, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns unauthorized status if user is not authenticated' do
      cookies[:username] = encrypt('fakeuser')
      get :auth_verification, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

  end

end
