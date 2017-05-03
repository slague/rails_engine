require 'rails_helper'

describe 'InvoiceItem API' do
  context 'record end points' do
    attr_reader :invoice_item1, :invoice_item2, :time

    before do
      @time = DateTime.new(2016, 5, 1, 20, 13, 20)
      @invoice_item1, @invoice_item2 = create_list(:invoice_item, 2)
    end

    it 'returns all invoice_items' do
      get '/api/v1/invoice_items.json'
      expect(response).to be_success

      invoice_items = JSON.parse(response.body)

      expect(invoice_items.first['id']).to eq(invoice_item1.id)
      expect(invoice_items.first['quantity']).to eq(invoice_item1.quantity)
      expect(invoice_items.first['unit_price']).to eq(invoice_item1.unit_price)
      expect(invoice_items.first).to_not have_key 'created_at'
      expect(invoice_items.first).to_not have_key 'updated_at'

      expect(invoice_items.last['id']).to eq(invoice_item2.id)
      expect(invoice_items.last['quantity']).to eq(invoice_item2.quantity)
      expect(invoice_items.last['unit_price']).to eq(invoice_item2.unit_price)
      expect(invoice_items.last).to_not have_key 'created_at'
      expect(invoice_items.last).to_not have_key 'updated_at'
    end

    it 'returns one invoice_item' do
      get "/api/v1/invoice_items/#{invoice_item1.id}.json"

      expect(response).to be_success

      invoice_item = JSON.parse(response.body)

      expect(invoice_item['id']).to eq(invoice_item1.id)
      expect(invoice_item['quantity']).to eq(invoice_item1.quantity)
      expect(invoice_item['unit_price']).to eq(invoice_item1.unit_price)

      expect(response.body).to_not include 'invoice_item2.id'
    end

    it 'can find a invoice_item by id' do
      create :invoice_item, id: 1
      create :invoice_item

      get '/api/v1/invoice_items/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find a invoice_item by unit_price' do
      create :invoice_item, unit_price: 2000
      create :invoice_item

      get '/api/v1/invoice_items/find?unit_price=2000'

      result = JSON.parse(response.body)

      expect(result['unit_price']).to eq(2000)
    end

    it 'can find an invoice_item by quantity' do
      create :invoice_item, quantity: 22
      create :invoice_item

      get '/api/v1/invoice_items/find?quantity=22'

      result = JSON.parse(response.body)

      expect(result['quantity']).to eq(22)
    end

    it 'can find a invoice_item by created_at' do
      create :invoice_item, created_at: time
      create :invoice_item

      get '/api/v1/invoice_items/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      new_invoice_item = InvoiceItem.find(result['id'])

      expect(new_invoice_item.created_at).to eq(time)
    end

    it 'can find a invoice_item by updated_at' do
      create :invoice_item, updated_at: time
      create :invoice_item

      get '/api/v1/invoice_items/find?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      new_invoice_item = InvoiceItem.find(result['id'])

      expect(new_invoice_item.updated_at).to eq(time)
    end

    it 'can find all invoice_items by id' do
      create :invoice_item, id: 1
      create :invoice_item, id: 2

      get '/api/v1/invoice_items/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result.first['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all invoice_items by quantity' do
      create :invoice_item, quantity: 22
      create :invoice_item, quantity: 22
      create :invoice_item, quantity: 102

      get '/api/v1/invoice_items/find_all?quantity=22'

      result = JSON.parse(response.body)
      expect(result[0]['quantity']).to eq 22
      expect(result[1]['quantity']).to eq 22
      expect(result.count).to eq 2
    end

    it 'can find all invoice_items by unit_price' do
      unit_price = 2000
      create :invoice_item, unit_price: unit_price
      create :invoice_item, unit_price: unit_price
      create :invoice_item, unit_price: 2

      get '/api/v1/invoice_items/find_all?unit_price=' + unit_price.to_s

      result = JSON.parse(response.body)

      expect(result.first['unit_price']).to eq unit_price
      expect(result.last['unit_price']).to eq unit_price
      expect(result.count).to eq 2
    end

    it 'can find all invoice_items by created_at' do
      create :invoice_item, created_at: time
      create :invoice_item, created_at: time

      create :invoice_item, created_at: time + 1

      get '/api/v1/invoice_items/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      invoice_items = result.map do |invoice_item|
        InvoiceItem.find(invoice_item['id'])
      end

      expect(invoice_items[0]['created_at']).to eq time
      expect(invoice_items[1]['created_at']).to eq time
      expect(invoice_items.count).to eq 2
    end

    it 'can find all invoice_items by updated_at' do
      create :invoice_item, updated_at: time
      create :invoice_item, updated_at: time
      create :invoice_item, updated_at: time + 1

      get '/api/v1/invoice_items/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      invoice_items = result.map do |invoice_item|
        InvoiceItem.find(invoice_item['id'])
      end

      expect(invoice_items[0]['updated_at']).to eq time
      expect(invoice_items[1]['updated_at']).to eq time
      expect(invoice_items.count).to eq 2
    end

    it 'can return a random record' do
      DatabaseCleaner.clean
      invoice_item1 = create :invoice_item, quantity: 3
      invoice_item2 = create :invoice_item, quantity: 4

      get '/api/v1/invoice_items/random'

      expect(response).to be_success

      result = JSON.parse(response.body)

      if result['id'] == invoice_item1.id
        expect(result['quantity']).to eq(invoice_item1.quantity)
      elsif result['id'] == invoice_item2.id
        expect(result['quantity']).to eq(invoice_item2.quantity)
      else
        expect('uh oh').to eq 'This shouldnt happen'
      end
    end
  end
end
