FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { Faker::Number.number(digits: 2) }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
