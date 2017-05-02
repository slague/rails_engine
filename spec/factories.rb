FactoryGirl.define do
  factory :merchant do
    sequence(:name) do |n|
      "Merchant ##{n}"
    end

    created_at DateTime.new(2017, 5, 1, 20, 13, 20)
    updated_at DateTime.new(2017, 5, 1, 20, 13, 20)
  end

  factory :item do
    sequence(:name) do |n|
      "Item ##{n}"
    end
    description 'Item description'
    unit_price  1000
    merchant
    created_at DateTime.new(2017, 5, 1, 20, 13, 20)
    updated_at DateTime.new(2017, 5, 1, 20, 13, 20)
  end
end
