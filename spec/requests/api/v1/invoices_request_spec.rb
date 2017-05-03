require 'rails_helper'

describe 'Invoices API' do
  context 'record end points' do
    attr_reader :time

    before do
      @time = DateTime.new(2017, 5, 1, 20, 13, 20)
    end

    it 'sends all invoices' do
      original_invoices = create_list(:invoice, 2)

      get '/api/v1/invoices.json'

      expect(response).to be_success

      invoices = JSON.parse response.body
      invoice = invoices.first

      expect(invoices.count).to eq 2
      expect(invoice['status']).to eq original_invoices.first.status
      expect(invoice).to_not have_key 'created_at'
      expect(invoice).to_not have_key 'updated_at'
    end

    it 'can show one invoice' do
      invoice = create :invoice

      get "/api/v1/invoices/#{invoice.id}.json"

      expect(response).to be_success

      response_invoice = JSON.parse response.body

      expect(response_invoice['id']).to eq invoice.id
      expect(response_invoice['status']).to eq invoice.status
      expect(response_invoice).to_not have_key 'created_at'
      expect(response_invoice).to_not have_key 'updated_at'
    end

    it 'can find a invoice by id' do
      create :invoice, id: 1
      create :invoice

      get '/api/v1/invoices/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find a invoice by name' do
      create :invoice, status: 'shipped'
      create :invoice

      get '/api/v1/invoices/find?status=shipped'

      result = JSON.parse(response.body)

      expect(result['status']).to eq('shipped')
    end

    it 'can find a invoice by created_at' do
      create :invoice, created_at: time
      create :invoice

      get '/api/v1/invoices/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      new_invoice = Invoice.find(result['id'])

      expect(new_invoice.created_at).to eq(time)
    end

    it 'can find a invoice by updated_at' do
      create :invoice, updated_at: time
      create :invoice

      get '/api/v1/invoices/find?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      new_invoice = Invoice.find(result['id'])

      expect(new_invoice.updated_at).to eq(time)
    end

    it 'can find all invoices by id' do
      create :invoice, id: 1
      create :invoice, id: 2

      get '/api/v1/invoices/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result[0]['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all invoices by status' do
      create :invoice, status: 'shipped'
      create :invoice, status: 'shipped'
      create :invoice, status: 'pending'

      get '/api/v1/invoices/find_all?status=shipped'

      result = JSON.parse(response.body)
      expect(result[0]['status']).to eq 'shipped'
      expect(result[1]['status']).to eq 'shipped'
      expect(result.count).to eq 2
    end

    it 'can find all invoices by created_at' do
      create :invoice, created_at: time
      create :invoice, created_at: time
      create :invoice, created_at: time + 1

      get '/api/v1/invoices/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      invoices = result.map do |invoice|
        Invoice.find(invoice['id'])
      end

      expect(invoices[0]['created_at']).to eq time
      expect(invoices[1]['created_at']).to eq time
      expect(invoices.count).to eq 2
    end

    it 'can find all invoices by updated_at' do
      create :invoice, updated_at: time
      create :invoice, updated_at: time
      create :invoice, updated_at: time + 1

      get '/api/v1/invoices/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      invoices = result.map do |invoice|
        Invoice.find(invoice['id'])
      end

      expect(invoices[0]['updated_at']).to eq time
      expect(invoices[1]['updated_at']).to eq time
      expect(invoices.count).to eq 2
    end

    it 'can return a random record' do
      invoice1 = create :invoice, status: 'shipped'
      invoice2 = create :invoice, status: 'pending'

      get '/api/v1/invoices/random'
      expect(response).to be_success

      result = JSON.parse(response.body)

      if result['id'] == invoice1.id
        expect(result['status']).to eq invoice1.status
      elsif result['id'] == invoice2.id
        expect(result['status']).to eq invoice2.status
      else
        expect('uh oh').to eq 'This shouldnt happen'
      end
    end
  end
end
