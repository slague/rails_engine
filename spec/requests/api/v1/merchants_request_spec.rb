require 'rails_helper'

describe 'Merchants API' do
  context 'record end points' do
    attr_reader :time

    before do
      @time = DateTime.new(2017, 5, 1, 20, 13, 20)
    end

    it 'sends all merchants' do
      original_merchants = create_list(:merchant, 2)

      get '/api/v1/merchants.json'

      merchants = JSON.parse response.body
      merchant = merchants.first

      expect(merchants.count).to eq 2
      expect(merchant['name']).to eq original_merchants.first.name
      expect(merchant).to_not have_key 'created_at'
      expect(merchant).to_not have_key 'updated_at'
    end

    it 'can show one merchant' do
      merchant = create :merchant

      get "/api/v1/merchants/#{merchant.id}.json"

      expect(response).to be_success

      response_merchant = JSON.parse response.body

      expect(response_merchant['id']).to eq merchant.id
      expect(response_merchant['name']).to eq merchant.name
      expect(response_merchant).to_not have_key 'created_at'
      expect(response_merchant).to_not have_key 'updated_at'
    end

    it 'can find a merchant by id' do
      create :merchant, id: 1
      get '/api/v1/merchants/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find a merchant by name' do
      create :merchant, name: "person"
      get '/api/v1/merchants/find?name=person'

      result = JSON.parse(response.body)

      expect(result['name']).to eq('person')
    end

    it 'can find a merchant by created_at' do
      create :merchant, created_at: time
      get '/api/v1/merchants/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      new_merchant = Merchant.find(result['id'])

      expect(new_merchant.created_at).to eq(time)
    end

    it 'can find a merchant by updated_at' do
      create :merchant, updated_at: time
      get '/api/v1/merchants/find?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      new_merchant = Merchant.find(result['id'])

      expect(new_merchant.updated_at).to eq(time)
    end

    it 'can find a random merchant' do
      merchant1 = create :merchant
      merchant2 = create :merchant
      get '/api/v1/merchants/random'

      expect(response).to be_success

      response_merchant = JSON.parse(response.body)

      if response_merchant['id'] == merchant1.id
        expect(response_merchant['name']).to eq(merchant1.name)
      elsif response_merchant['id'] == merchant2.id
        expect(response_merchant['name']).to eq(merchant2.name)
      else
        expect('uh oh').to eq('This should not happen')
      end
    end

    it 'can find all merchants by id' do
      create :merchant, id: 1
      create :merchant, id: 2

      get '/api/v1/merchants/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result[0]['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all merchants by name' do
      create :merchant, name: 'Sam'
      create :merchant, name: 'Sam'
      create :merchant, name: 'Stephanie'

      get '/api/v1/merchants/find_all?name=Sam'

      result = JSON.parse(response.body)
      expect(result[0]['name']).to eq 'Sam'
      expect(result[1]['name']).to eq 'Sam'
      expect(result.count).to eq 2
    end

    it 'can find all merchants by created_at' do
      create :merchant, created_at: time
      create :merchant, created_at: time
      create :merchant, created_at: time + 1

      get '/api/v1/merchants/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      merchants = result.map do |merchant|
        Merchant.find(merchant['id'])
      end

      expect(merchants[0]['created_at']).to eq time
      expect(merchants[1]['created_at']).to eq time
      expect(merchants.count).to eq 2
    end

    it 'can find all merchants by updated_at' do
      create :merchant, updated_at: time
      create :merchant, updated_at: time
      create :merchant, updated_at: time + 1

      get '/api/v1/merchants/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      merchants = result.map do |merchant|
        Merchant.find(merchant['id'])
      end

      expect(merchants[0]['updated_at']).to eq time
      expect(merchants[1]['updated_at']).to eq time
      expect(merchants.count).to eq 2
    end
  end

  context 'business intelligence end points' do
    attr_reader :merchant1, :merchant2, :merchant3

    before do
      transaction = create :transaction
      transaction2 = create :transaction
      invoice = create :invoice
      invoice2 = create :invoice, created_at: DateTime.now
      invoice.invoice_items << create(:invoice_item, quantity: 1, unit_price: 5000)
      invoice.invoice_items << create(:invoice_item, quantity: 2, unit_price: 5000)
      invoice2.invoice_items << create(:invoice_item, quantity: 3, unit_price: 5000)
      invoice2.invoice_items << create(:invoice_item, quantity: 4, unit_price: 5000)
      invoice.transactions << transaction
      invoice2.transactions << transaction2
      test_date = DateTime.new(2017, 3, 31, 1, 2, 3)

      @merchant1 = create :merchant, invoices: [invoice, invoice2]

      transaction = create :transaction
      invoice = create :invoice, created_at: test_date
      invoice.invoice_items << create(:invoice_item, quantity: 5, unit_price: 5000)
      invoice.invoice_items << create(:invoice_item, quantity: 6, unit_price: 5001)
      invoice.transactions << transaction

      @merchant2 = create :merchant, invoices: [invoice]

      transaction = create :transaction
      invoice = create :invoice, created_at: test_date
      invoice.invoice_items << create(:invoice_item, quantity: 7, unit_price: 5001)
      invoice.invoice_items << create(:invoice_item, quantity: 8, unit_price: 5001)
      invoice.transactions << transaction

      @merchant3 = create :merchant, invoices: [invoice]

    end

    it 'returns the top x merchants ranked by total revenue' do
      get '/api/v1/merchants/most_revenue?quantity=2'

      expect(response).to be_success
      result = JSON.parse(response.body)

      top_merchants = result.map do |merchant|
        Merchant.find(merchant['id'])
      end

      expect(top_merchants.first).to eq merchant3
      expect(top_merchants.last).to eq merchant2
      expect(top_merchants).to_not include merchant1
    end

    it 'returns a merchants revenue' do
      get "/api/v1/merchants/#{merchant2.id}/revenue.json"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['revenue']).to eq merchant2.revenue
    end

    it 'returns a merchants revenue on a given day' do
      get "/api/v1/merchants/#{merchant1.id}/revenue?date=2017-05-01"

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result['revenue']).to eq('150.00')
    end

    it 'returns every merchants revenue on a given date' do
      revenue = (merchant2.revenue.to_f + merchant3.revenue.to_f).round(2).to_s
      get '/api/v1/merchants/most_revenue?date=2017-03-31'

      expect(response).to be_success

      result = JSON.parse(response.body)
      expect(result['revenue']).to eq(revenue)
    end

    it 'returns merchants that sell the most items' do
      get '/api/v1/merchants/most_items?quantity=2'

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(result.count).to eq 2
      expect(result.first).to eq merchant3
      expect(result.last).to eq merchant2
    end
  end
end
