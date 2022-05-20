require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    it '.find_by_name' do
      merchant_1 = Merchant.create(name: "Joe's Cakes")
      merchant_2 = Merchant.create(name: "Amy's Cakes")
      merchant_3 = Merchant.create(name: "Carol's Cakes")
      merchant_4 = Merchant.create(name: "Bob's Steaks")

      expect(Merchant.find_by_name("cakes")).to eq([merchant_2, merchant_3, merchant_1])
    end
  end
end
