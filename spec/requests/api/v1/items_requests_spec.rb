require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'all items' do
    it 'returns all items' do
      merchant = create_list(:merchant, 1).first
      create_list(:item, 5, merchant: merchant)

      get '/api/v1/items'

      items_response = JSON.parse(response.body, symbolize_names: true)
      items = items_response[:data]

      expect(response).to be_successful
      expect(items.count).to eq(5)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an String

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a String

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a Float

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a Integer
      end
    end
  end
end
