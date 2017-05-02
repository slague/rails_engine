require 'rails_helper'

RSpec.describe Merchant do
    attr_reader :time
    before do
      @time = DateTime.new(2017,5,1,20,13,20)
    end
  context 'validations' do
    it 'is valid with a name, created_at, and updated_at' do
      merchant = Merchant.new(name: "seller person", created_at: time, updated_at: time)

      expect(merchant).to be_valid
    end
    it 'is invalid without a name' do
      merchant = Merchant.new(created_at: time, updated_at: time)

      expect(merchant).to_not be_valid
    end

    it 'is invalid without created_at' do
      merchant = Merchant.new(name: "seller person", updated_at: time)

      expect(merchant).to_not be_valid
    end

    it 'is invalid without updated_at' do
      merchant = Merchant.new(name: "seller person", created_at: time)

      expect(merchant).to_not be_valid
    end
  end

  context 'relationships' do
    it 'has many items' do
      items = create_list(:item, 2)
      merchant = Merchant.create(name: "seller person", created_at: time, updated_at: time)
      merchant.items << items

      expect(merchant.items).to include(items.first)
      expect(merchant.items).to include(items.last)

    end
  end
end
