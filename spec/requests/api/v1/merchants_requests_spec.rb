require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "all merchants" do
    it 'returns a list of all merchants' do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful
    end
  end
end
