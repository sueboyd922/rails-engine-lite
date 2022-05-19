class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  def solo_invoices
    # wip = invoices.find_by_sql("SELECT invoices.*, count(invoice_items) FROM invoices INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id GROUP BY invoices.id")
    wip = invoices.select("invoices.*, count(invoice_items) as item_count")
    .joins(:invoice_items)
    .group(:id)
    wip.select {|invoice| invoice.item_count == 1}
  end
end
