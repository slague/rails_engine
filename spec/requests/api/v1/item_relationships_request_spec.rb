require 'rails_helper'

describe 'Item Relationship API' do
  context 'relationship end points' do

    it 'returns the merchant associated with an item' do
      merchant1 = create :merchant
      merchant2 = create :merchant
      item1 = create :item, merchant_id: merchant1.id
      item2 = create :item, merchant_id: merchant2.id

      get "/api/v1/items/#{item1.id}/merchant.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(merchant1.id)
      expect(result['name']).to eq(merchant1.name)
    end

    it 'returns a collection of invoice_items associated with an item' do
      item = create :item
      invoice_item1 = create :invoice_item, item_id: item.id
      invoice_item2 = create :invoice_item, item_id: item.id

      get "/api/v1/items/#{item.id}/invoice_items.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['quantity']).to eq(invoice_item1.quantity)
      expect(result[1]['quantity']).to eq(invoice_item2.quantity)
      expect(result[0]['unit_price']).to eq(invoice_item1.unit_price)
      expect(result[1]['unit_price']).to eq(invoice_item2.unit_price)
      expect(result.count).to eq(2)
    end
  end
end
