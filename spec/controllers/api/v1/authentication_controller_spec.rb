require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  describe 'authenticatoin#login' do
    it 'create returns http success status' do
      post :login, as: :json, params: {username: 'TestUser', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:success)
    end

    it 'create returns http not_found status for bad credentials' do
      post :login, as: :json, params: {username: 'Fake', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'authenticatoin#logout' do
    it 'create returns http success' do
      delete :logout, as: :json
      expect(response).to have_http_status(:success)
      expect(cookies[:username]).to eq('')
    end
  end
end
