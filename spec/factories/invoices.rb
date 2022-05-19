FactoryBot.define do
  factory :invoice do
    customer { nil }
    merchant { nil }
    status { "status" }
  end
end
