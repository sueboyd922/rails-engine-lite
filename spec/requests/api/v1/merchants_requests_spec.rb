require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "all merchants" do
    it 'returns a list of all merchants' do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants_response = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_response[:data]

      expect(merchants.count).to eq(5)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a String

        expect(merchant[:type]).to eq("merchant")

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a String
      end
    end
  end

  describe 'one merchant' do
    it 'gets the info from one merchant' do
      merchant = create_list(:merchant, 1).first

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful
      merchant_response = JSON.parse(response.body, symbolize_names: true)
      merchant = merchant_response[:data]

      expect(merchant).to be_a Hash
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a String
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String
      expect(merchant[:type]).to eq("merchant")
    end
  end

  describe 'merchants items endpoint' do
    it 'returns all items of a single merchant' do
      merchants = create_list(:merchant, 2)
      merchant_1 = merchants.first
      merchant_2 = merchants.last

      merch_1_items = create_list(:item, 5, merchant_id: merchant_1.id)
      merch_2_items = create_list(:item, 3, merchant_id: merchant_2.id)

      get "/api/v1/merchants/#{merchant_1.id}/items"
      merchant_response = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry

      expect(response).to be_successful


    end
  end
end
