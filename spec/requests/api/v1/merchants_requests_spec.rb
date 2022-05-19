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
      items = merchant_response[:data]

      expect(response).to be_successful
      expect(items.count).to eq(5)

      items_ids = items.map {|item| item[:id].to_i}
      merch_2_items.each do |item|
        expect(items_ids.include?(item.id)).to be false
      end
      merch_1_items.each do |item|
        expect(items_ids.include?(item.id)).to be true
      end

      items.each do |item|
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
        expect(item[:attributes][:merchant_id]).to be_a Integer
      end
    end
  end

  describe 'search endpoints' do
    describe 'find one merchant' do
      it 'finds one merchant from a search' do
        create_list(:merchant, 4)
        merchant = Merchant.create!(name: "Sammy's Sandy Sandwiches")

        get "/api/v1/merchants/find?name=Sandy"

        expect(response).to be_successful
        merchant_response = JSON.parse(response.body, symbolize_names: true)
        found_merchant = merchant_response[:data]

        expect(found_merchant).to be_a Hash
        expect(found_merchant).to have_key(:id)
        expect(found_merchant[:id]).to be_a String
        expect(found_merchant[:attributes]).to have_key(:name)
        expect(found_merchant[:attributes][:name]).to eq("Sammy's Sandy Sandwiches")
        expect(found_merchant[:type]).to eq("merchant")
      end

      it 'returns the first match in alphabetical order' do
        merchant_1 = Merchant.create!(name: "Meat my Cows")
        merchant_2 = Merchant.create!(name: "Veggie Bonanza")
        merchant_3 = Merchant.create!(name: "All the Meats")
        merchant_4 = Merchant.create!(name: "Viva las Veggies")

        get "/api/v1/merchants/find?name=meat"

        expect(response).to be_successful
        merchant_response = JSON.parse(response.body, symbolize_names: true)
        found_merchant = merchant_response[:data]

        expect(found_merchant.class).to eq Hash
        expect(found_merchant[:attributes][:name]).to eq("All the Meats")
      end

      it 'can return an empty result' do
        merchant_1 = Merchant.create!(name: "Meat my Cows")
        merchant_2 = Merchant.create!(name: "Veggie Bonanza")
        merchant_3 = Merchant.create!(name: "All the Meats")
        merchant_4 = Merchant.create!(name: "Viva las Veggies")

        get "/api/v1/merchants/find?name=chicken"

        expect(response.status).to eq(200)
        merchant_response = JSON.parse(response.body, symbolize_names: true)
        no_results = merchant_response[:data]

        expect(no_results).to be_a Hash
        expect(no_results.empty?).to be true
      end

      it 'returns an error when the search is empty' do
        merchant_1 = Merchant.create!(name: "Meat my Cows")
        merchant_2 = Merchant.create!(name: "Veggie Bonanza")
        merchant_3 = Merchant.create!(name: "All the Meats")
        merchant_4 = Merchant.create!(name: "Viva las Veggies")

        get "/api/v1/merchants/find?name="

        expect(response.status).to eq(400)
      end

      it 'returns an error when the parameter is missing' do
        merchant_1 = Merchant.create!(name: "Meat my Cows")
        merchant_2 = Merchant.create!(name: "Veggie Bonanza")
        merchant_3 = Merchant.create!(name: "All the Meats")
        merchant_4 = Merchant.create!(name: "Viva las Veggies")

        get "/api/v1/merchants/find"

        expect(response.status).to eq(400)
      end
    end
  end
end
