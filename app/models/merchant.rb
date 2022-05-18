class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant(id)
    where(id: id)
  end
end
