require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe 'GET /' do
    it 'shows the address form' do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Enter an address')
    end
  end

end
