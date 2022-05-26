class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices

  def self.find_by_name(search)
    where("name ilike ?", "%#{search}%")
    .order(:name)
  end
end
