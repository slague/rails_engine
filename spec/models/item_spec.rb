require 'rails_helper'

RSpec.describe Item do
  attr_reader :merchant, :item1, :item2, :item3, :item4, :item5, :item6

  before do
    @merchant = create :merchant
    @item1 = Item.create(name: 'Hot dog',
                         description: 'Um...',
                         unit_price: 1000,
                         merchant_id: merchant.id)
    @item2 = Item.new(description: 'Um...',
                      unit_price: 1000,
                      merchant_id: merchant.id)
    @item3 = Item.new(name: 'Hot dog',
                      unit_price: 1000,
                      merchant_id: merchant.id)
    @item4 = Item.new(name: 'Hot dog',
                      description: 'Um...',
                      merchant_id: merchant.id)
    @item5 = Item.new(name: 'Hot dog',
                      description: 'Um...',
                      unit_price: 1000)
    @item6 = Item.new(name: 'Hot dog',
                      description: 'Um...',
                      unit_price: 1000,
                      merchant_id: merchant.id)
  end

  context 'validations' do
    it { expect(item1).to be_valid }
    it { expect(item2).to_not be_valid }
    it { expect(item3).to_not be_valid }
    it { expect(item4).to_not be_valid }
    it { expect(item5).to_not be_valid }

    it 'has a unique name' do
      expect(item6).to_not be_valid
    end
  end

  context 'relationships' do
    it 'has a merchant' do
      expect(item1.merchant).to eq merchant
    end
  end
end
