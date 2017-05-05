require 'rails_helper'

describe 'Invoice Relationship API' do
  context 'relationship end points' do

    it 'returns a collection of associated transactions' do
      invoice = create :invoice
      transaction1 = create :transaction, invoice_id: invoice.id
      transaction2 = create :transaction, invoice_id: invoice.id

      get "/api/v1/invoices/#{invoice.id}/transactions.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['id']).to eq(transaction1.id)
      expect(result[1]['id']).to eq(transaction2.id)
      expect(result.count).to eq(2)
    end

    it 'returns a collection of associated invoice_items' do
      invoice = create :invoice
      invoice_item1 = create :invoice_item, invoice_id: invoice.id
      invoice_item2 = create :invoice_item, invoice_id: invoice.id

      get "/api/v1/invoices/#{invoice.id}/invoice_items.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['id']).to eq(invoice_item1.id)
      expect(result[1]['id']).to eq(invoice_item2.id)
      expect(result.count).to eq(2)
    end

    it 'returns a collection of associated items' do
      invoice = create :invoice
      item1 = create :item
      item2 = create :item
      invoice_item1 = create :invoice_item, invoice_id: invoice.id, item_id: item1.id
      invoice_item2 = create :invoice_item, invoice_id: invoice.id, item_id: item2.id

      get "/api/v1/invoices/#{invoice.id}/items.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result[0]['id']).to eq(item1.id)
      expect(result[1]['id']).to eq(item2.id)
      expect(result.count).to eq(2)
    end

    it 'returns a the associated customer' do
      customer = create :customer
      invoice = create :invoice, customer_id: customer.id

      get "/api/v1/invoices/#{invoice.id}/customer.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(customer.id)
      expect(result['first_name']).to eq(customer.first_name)
      expect(result['last_name']).to eq(customer.last_name)
    end

    it 'returns a the associated merchant' do
      merchant = create :merchant
      invoice = create :invoice, merchant_id: merchant.id

      get "/api/v1/invoices/#{invoice.id}/merchant.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['id']).to eq(merchant.id)
      expect(result['name']).to eq(merchant.name)
    end
  end
end
