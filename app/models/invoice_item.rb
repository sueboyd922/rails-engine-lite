class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  has_one :item
  has_one :invoice
end
