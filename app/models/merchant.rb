class Merchant < ApplicationRecord

  def self.find_merchant(id)
    where(id: id)
  end
end
