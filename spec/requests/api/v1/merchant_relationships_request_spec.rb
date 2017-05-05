require 'rails_helper'

describe 'Merchant Relationship API' do
  context 'relationship end points' do

    it 'returns a collection of items associated with a merchant' do
      merchant = create :merchant
      item1 = create :item, merchant_id: merchant.id
      item2 = create :item, merchant_id: merchant.id

      get "/api/v1/merchants/#{merchant.id}/items.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['name']).to eq(item1.name)
      expect(result[1]['name']).to eq(item2.name)
      expect(result.count).to eq 2
    end

    it 'returns a collection of invoices associated with a merchant' do
      merchant = create :merchant
      invoice1 = create :invoice, merchant_id: merchant.id
      invoice2 = create :invoice, merchant_id: merchant.id

      get "/api/v1/merchants/#{merchant.id}/invoices.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['status']).to eq(invoice1.status)
      expect(result[1]['status']).to eq(invoice2.status)
      expect(result.count).to eq 2
    end
  end
end
