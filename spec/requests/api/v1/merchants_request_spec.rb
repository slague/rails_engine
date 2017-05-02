require 'rails_helper'

describe 'Merchants API' do
  context 'record end points' do
    attr_reader :time
    before do
      @time = DateTime.new(2017,5,1,20,13,20)
	  end
    it 'sends all merchants' do
	    original_merchants = create_list(:merchant, 2)

	    get '/api/v1/merchants.json'

	    expect(response).to be_success

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
      get '/api/v1/merchants/find?created_at='+ time.to_s

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

      get '/api/v1/merchants/find_all?created_at='+ time.to_s

      result = JSON.parse(response.body)
      merchants = result.map do |result|
        Merchant.find(result['id'])
      end

      expect(merchants[0]['created_at']).to eq time
      expect(merchants[1]['created_at']).to eq time
      expect(merchants.count).to eq 2
    end

    it 'can find all merchants by updated_at' do
      merchant = create :merchant, updated_at: time
      merchant = create :merchant, updated_at: time
      merchant = create :merchant, updated_at: time + 1

      get '/api/v1/merchants/find_all?updated_at='+ time.to_s

      result = JSON.parse(response.body)
      merchants = result.map do |result|
        Merchant.find(result['id'])
      end

      expect(merchants[0]['updated_at']).to eq time
      expect(merchants[1]['updated_at']).to eq time
      expect(merchants.count).to eq 2
    end
  end

  context 'business intelligence end points' do
    xit 'returns the top x merchants ranked by total revenue' do


    end

  end
end
