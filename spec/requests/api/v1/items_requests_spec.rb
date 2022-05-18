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

  describe 'create functionality' do
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
      expect(response.status).to eq(201)

      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'only creates it if all attributes are present' do
      merchant = create_list(:merchant, 1).first
      item_params = {
              name: "Firebolt",
              unit_price: 895.23,
              merchant_id: merchant.id
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response.status).to eq(400)
    end
  end

  describe 'update functionality' do
    it 'can update an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      original_name = item.name
      item_params = {name: "Funky Candle"}
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
      updated_item = Item.find(item.id)
      expect(response).to be_successful
      expect(updated_item.name).not_to eq(original_name)
      expect(updated_item.name).to eq("Funky Candle")
    end

    it "returns an error if merchant_id doesn't exist" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      new_merchant_id = merchant.id + 1
      item_params = {merchant_id: new_merchant_id}
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

      expect(response.status).to eq(404)
      failed_item = Item.find(item.id)
      expect(failed_item.merchant_id).not_to eq(new_merchant_id)
      expect(failed_item.merchant_id).to eq(merchant.id)
    end
  end

  describe 'relationship with merchant' do
    it 'can return the merchant info for an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      merchant_response = JSON.parse(response.body, symbolize_names: true)
      returned_merchant = merchant_response[:data]

      expect(returned_merchant).to have_key(:id)
      expect(returned_merchant[:id]).to be_a String

      expect(returned_merchant).to have_key(:type)
      expect(returned_merchant[:type]).to eq("merchant")

      expect(returned_merchant[:attributes]).to have_key(:name)
      expect(returned_merchant[:attributes][:name]).to be_a String
    end

    it 'returns an error if the item does not exist' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id + 1}/merchant"

      expect(response.status).to eq(404)
    end
  end

  

end
