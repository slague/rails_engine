require 'rails_helper'

describe 'InvoiceItem Relationship API' do
  context 'relationship end points' do

    it 'returns a the associated invoice' do
      invoice = create :invoice
      invoice_item = create :invoice_item, invoice_id: invoice.id

      get "/api/v1/invoice_items/#{invoice_item.id}/invoice.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(invoice.id)
      expect(result['status']).to eq(invoice.status)
      expect(result['merchant_id']).to eq(invoice.merchant_id)
    end

    it 'returns a the associated item' do
      item = create :item
      invoice_item = create :invoice_item, item_id: item.id

      get "/api/v1/invoice_items/#{invoice_item.id}/item.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(item.id)
      expect(result['name']).to eq(item.name)
      expect(result['merchant_id']).to eq(item.merchant_id)
    end
  end
end
