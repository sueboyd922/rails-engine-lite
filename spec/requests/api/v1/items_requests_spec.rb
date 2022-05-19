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


  describe "delete functionality" do
    it 'can delete an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      delete "/api/v1/items/#{item.id}"
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Item.count).to be(0)
      expect(Item.exists?(item.id)).to be false
    end

    it 'throws an error if item does not exist' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      delete "/api/v1/items/#{item.id + 1}"
      expect(response.status).to eq(404)
    end

    it 'destroys invoices if it was only item on an invoice' do
      merchant = create(:merchant)
      customer = create(:customer)

      items = create_list(:item, 3, merchant_id: merchant.id)
      item_1 = items[0]
      item_2 = items[1]
      item_3 = items[2]

      invoice_1 = Invoice.create!(merchant: merchant, customer: customer)
      invoice_2 = Invoice.create!(merchant: merchant, customer: customer)
      invoice_3 = Invoice.create!(merchant: merchant, customer: customer)

      invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1)
      invoice_item_2 = InvoiceItem.create!(item: item_1, invoice: invoice_2)
      invoice_item_3 = InvoiceItem.create!(item: item_2, invoice: invoice_2)
      invoice_item_4 = InvoiceItem.create!(item: item_1, invoice: invoice_3)
      invoice_item_5 = InvoiceItem.create!(item: item_2, invoice: invoice_3)
      invoice_item_6 = InvoiceItem.create!(item: item_3, invoice: invoice_3)

      expect(invoice_2.invoice_items.count).to eq 2
      expect(invoice_3.invoice_items.count).to eq 3
      delete "/api/v1/items/#{item_1.id}"

      expect(Item.exists?(item_1.id)).to be false
      expect(Invoice.exists?(invoice_1.id)).to be false
      expect(Invoice.exists?(invoice_2.id)).to be true
      expect(invoice_2.invoice_items.count).to be 1
      expect(Invoice.exists?(invoice_3.id)).to be true
      expect(invoice_3.invoice_items.count).to be 2
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

  describe 'search functions' do
    describe 'find all items' do
      it 'finds all items from a name search' do
        merchant = create(:merchant)
        item_1 = create(:item, name: "Broomstick", merchant: merchant)
        item_2 = create(:item, name: "Dragon Egg", merchant: merchant)
        item_3 = create(:item, name: "Dozen eggs", merchant: merchant)
        item_4 = create(:item, name: "Emu feather", merchant: merchant)

        get "/api/v1/items/find_all?name=egg"
        expect(response).to be_successful

        items_response = JSON.parse(response.body, symbolize_names: true)
        item_results = items_response[:data]

        expect(item_results).to be_an Array
        expect(item_results.count).to eq(2)
        item_results.each do |item|
          expect(item[:attributes][:name].downcase.include?("egg")).to be true
        end
      end

      it 'returns an empty array if no results found' do
        merchant = create(:merchant)
        item_1 = create(:item, name: "Broomstick", merchant: merchant)
        item_2 = create(:item, name: "Dragon Egg", merchant: merchant)
        item_3 = create(:item, name: "Dozen eggs", merchant: merchant)
        item_4 = create(:item, name: "Emu feather", merchant: merchant)

        get "/api/v1/items/find_all?name=folder"
        expect(response).to be_successful

        items_response = JSON.parse(response.body, symbolize_names: true)
        item_results = items_response[:data]

        expect(item_results).to be_an Array
        expect(item_results.empty?).to be true
      end

      it 'returns an error if no search is entered' do
        merchant = create(:merchant)
        item_1 = create(:item, name: "Broomstick", merchant: merchant)
        item_2 = create(:item, name: "Dragon Egg", merchant: merchant)
        item_3 = create(:item, name: "Dozen eggs", merchant: merchant)
        item_4 = create(:item, name: "Emu feather", merchant: merchant)

        get "/api/v1/items/find_all?name="

        expect(response.status).to eq(400)
      end

      it 'returns an error if parameter is missing' do
        get "/api/v1/items/find_all"

        expect(response.status).to eq(400)
      end

      it 'finds items by min price' do
        merchant = create(:merchant)
        item_1 = create(:item, merchant_id: merchant.id, unit_price: 3.90)
        item_2 = create(:item, merchant_id: merchant.id, unit_price: 8.99)
        item_3 = create(:item, merchant_id: merchant.id, unit_price: 2.75)
        item_4 = create(:item, merchant_id: merchant.id, unit_price: 10.20)

        get "/api/v1/items/find_all?min_price=4.00"
        # require "pry"; binding.pry
        expect(response).to be_successful
        items_response = JSON.parse(response.body, symbolize_names: true)
        item_results = items_response[:data]

        expect(item_results.count).to eq 2
        expect(item_results).to be_an Array
      end

    end
  end
end

# merchant = create(:merchant)
# item_1 = create(:item, name: "Pencil", merchant_id: merchant.id, unit_price: 3.90)
# item_2 = create(:item, name: "Chair", merchant_id: merchant.id, unit_price: 8.99)
# item_3 = create(:item, name: "Hammock", merchant_id: merchant.id, unit_price: 2.75)
# item_4 = create(:item, name: "Robot Calendar", merchant_id: merchant.id, unit_price: 10.20)
