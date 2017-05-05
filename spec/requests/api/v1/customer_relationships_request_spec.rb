require 'rails_helper'

describe 'Customer Relationship API' do
  context 'relationship end points' do

    it 'returns a collection of associated invoices' do
      customer = create :customer
      invoice1 = create :invoice, customer_id: customer.id
      invoice2 = create :invoice, customer_id: customer.id

      get "/api/v1/customers/#{customer.id}/invoices.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['id']).to eq(invoice1.id)
      expect(result[1]['id']).to eq(invoice2.id)
      expect(result.count).to eq(2)
    end


    it 'returns a collection of associated transactions' do
      customer = create :customer
      invoice1 = create :invoice, customer_id: customer.id
      invoice2 = create :invoice, customer_id: customer.id
      transaction1 = create :transaction, invoice_id: invoice1.id
      transaction2 = create :transaction, invoice_id: invoice2.id

      get "/api/v1/customers/#{customer.id}/transactions.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['id']).to eq(transaction1.id)
      expect(result[1]['id']).to eq(transaction2.id)
      expect(result.count).to eq(2)
    end
  end
end
