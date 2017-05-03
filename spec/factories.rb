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

  factory :customer do
    sequence(:first_name) do |n|
      "first name #{n}"
    end
    sequence(:last_name) do |n|
      "last name #{n}"
    end
    created_at DateTime.new(2017, 5, 1, 20, 13, 20)
    updated_at DateTime.new(2017, 5, 1, 20, 13, 20)
  end

  factory :invoice do
    customer
    merchant
    status 'success'
    created_at DateTime.new(2017, 5, 1, 20, 13, 20)
    updated_at DateTime.new(2017, 5, 1, 20, 13, 20)
  end

  factory :transaction do
    invoice
    credit_card_number 4800749911485986
    result 'success'
    created_at DateTime.new(2017, 5, 1, 20, 13, 20)
    updated_at DateTime.new(2017, 5, 1, 20, 13, 20)
  end
end
