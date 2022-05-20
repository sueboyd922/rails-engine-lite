require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'class methods' do
    it '.find_all_by_name' do
      merchant = create(:merchant)
      item_1 = create(:item, name: "Broomstick", merchant: merchant)
      item_2 = create(:item, name: "Dragon Egg", merchant: merchant)
      item_3 = create(:item, name: "Dozen eggs", merchant: merchant)
      item_4 = create(:item, name: "Emu feather", merchant: merchant)

      expect(Item.find_all_by_name("egg").to_a).to eq([item_2, item_3])
    end

    it '.find_all_by_price' do
      merchant = create(:merchant)
      item_1 = create(:item, name: "A", merchant_id: merchant.id, unit_price: 3.90)
      item_2 = create(:item, name: "B", merchant_id: merchant.id, unit_price: 8.99)
      item_3 = create(:item, name: "C", merchant_id: merchant.id, unit_price: 2.75)
      item_4 = create(:item, name: "D", merchant_id: merchant.id, unit_price: 10.20)

      expect(Item.find_all_by_price("min", 6.04).to_a).to eq([item_2, item_4])
      expect(Item.find_all_by_price("max", 9.22).to_a).to eq([item_1, item_2, item_3])
      expect(Item.find_all_by_price("range", [2.90, 8.87]).to_a).to eq([item_1])
    end
  end

  describe 'instance methods' do
    it '#solo_invoices' do
      merchant = create(:merchant)
      customer = create(:customer)

      items = create_list(:item, 2, merchant_id: merchant.id)
      item_1 = items[0]
      item_2 = items[1]

      invoice_1 = Invoice.create!(merchant: merchant, customer: customer)
      invoice_2 = Invoice.create!(merchant: merchant, customer: customer)
      invoice_3 = Invoice.create!(merchant: merchant, customer: customer)

      invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1)
      invoice_item_2 = InvoiceItem.create!(item: item_1, invoice: invoice_2)
      invoice_item_3 = InvoiceItem.create!(item: item_2, invoice: invoice_2)
      invoice_item_4 = InvoiceItem.create!(item: item_1, invoice: invoice_3)

      expect(item_1.solo_invoices).to eq([invoice_1, invoice_3])
    end
  end
end
