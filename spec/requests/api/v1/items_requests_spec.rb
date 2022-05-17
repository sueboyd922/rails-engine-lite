require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'all items' do
    it 'returns all items' do
      create_list(:item, 5)

      get '/api/v1/items'

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
    end
  end
end
