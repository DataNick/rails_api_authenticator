require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  describe 'authenticatoin#login' do
    it 'login with correct credentials returns http success status' do
      post :login, as: :json, params: {username: 'TestUser', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:success)
    end

    it 'returns http not_found status for bad credentials' do
      post :login, as: :json, params: {username: 'Fake', password: 'Pa33w$0rd'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'authenticatoin#logout' do
    it 'returns http success' do
      delete :logout, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns an emptied cookie store' do
      delete :logout, as: :json
      expect(cookies[:username]).to eq('')
    end
  end
end
