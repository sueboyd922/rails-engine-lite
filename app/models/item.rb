class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  def self.find_all_by_name(search)
    where("name ilike ?", "%#{search}%")
  end

  def solo_invoices
    wip = invoices.joins(:invoice_items)
    .select("invoices.*, count(invoice_items) as item_count")
    .group(:id)
    wip.select {|invoice| invoice.item_count == 1}
  end

  def self.find_all_by_price(level, search)
    if level == "min"
      where("unit_price >= ?", search).order(:name)
    elsif level == "max"
      where("unit_price <= ?", search).order(:name)
    elsif level == "range"
      where(unit_price: search[0]..search[1]).order(:name)
    end
  end
end
