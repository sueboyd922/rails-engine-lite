class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, presence: true

  def self.find_all_by_name(search)
    where("name ilike ?", "%#{search}%")
  end
end
