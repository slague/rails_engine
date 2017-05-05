require 'rails_helper'

describe 'Transaction Relationship API' do
  context 'relationship end points' do

    it 'returns a the associated invoice' do
      invoice = create :invoice
      transaction = create :transaction, invoice_id: invoice.id

      get "/api/v1/transactions/#{transaction.id}/invoice.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(invoice.id)
      expect(result['status']).to eq(invoice.status)
      expect(result['merchant_id']).to eq(invoice.merchant_id)
    end
  end 
end
