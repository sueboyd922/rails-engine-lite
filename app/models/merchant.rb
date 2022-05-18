class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(search)
    where("name like ?", "%#{search}%")
  end
end
