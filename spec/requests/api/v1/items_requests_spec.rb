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

        expect(item[:type]).to eq("item")

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a String

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a Float

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a Integer
      end
    end
  end

  describe 'one item' do
    it 'returns info for one item' do
      merchant = create_list(:merchant, 1).first
      create_list(:item, 5, merchant: merchant)
      item = Item.last

      get "/api/v1/items/#{item.id}"

      item_response = JSON.parse(response.body, symbolize_names: true)
      item = item_response[:data]

      expect(response).to be_successful

      expect(item).to be_a Hash
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end
  end

  describe 'create/update/delete functionality' do
    it 'can create a new item' do
      merchant = create_list(:merchant, 1).first
      item_params = {
              name: "Firebolt",
              description: "Go really fast",
              unit_price: 895.23,
              merchant_id: merchant.id
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      new_item = Item.last

      expect(response).to be_successful
    end
  end
end
