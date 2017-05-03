require 'rails_helper'

describe 'Item API' do
  context 'record end points' do
    attr_reader :item1, :item2, :merchant, :time

    before do
      @time = DateTime.new(2018, 5, 1, 20, 13, 20)
      @merchant = create(:merchant)
      @item1, @item2 = create_list(:item, 2)
      merchant.items << [item1, item2]
    end

    it 'returns all items' do
      get '/api/v1/items.json'
      expect(response).to be_success

      items = JSON.parse(response.body)

      expect(items.first['name']).to eq(item1.name)
      expect(items.first['description']).to eq(item1.description)
      expect(items.first['unit_price']).to eq(item1.unit_price)
      expect(items.first).to_not have_key 'created_at'
      expect(items.first).to_not have_key 'updated_at'

      expect(items.last['name']).to eq(item2.name)
      expect(items.last['description']).to eq(item2.description)
      expect(items.last['unit_price']).to eq(item2.unit_price)
      expect(items.last).to_not have_key 'created_at'
      expect(items.last).to_not have_key 'updated_at'
    end

    it 'returns one item' do
      get "/api/v1/items/#{item1.id}.json"

      expect(response).to be_success

      item = JSON.parse(response.body)

      expect(item['name']).to eq(item1.name)
      expect(item['description']).to eq(item1.description)

      expect(response.body).to_not include item2.name
    end

    it 'can find an item by id' do
      create :item, id: 1
      create :item

      get '/api/v1/items/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find an item by name' do
      create :item, name: 'pickle'
      create :item

      get '/api/v1/items/find?name=pickle'

      result = JSON.parse(response.body)

      expect(result['name']).to eq('pickle')

      get '/api/v1/items/find?name=Pickle'

      result = JSON.parse(response.body)

      expect(result['name']).to eq('pickle')
    end

    it 'can find a item by description' do
      description = 'The finest artisan friendship bracelets'
      create :item, description: description
      create :item

      get '/api/v1/items/find?description=' + CGI.escape(description)

      result = JSON.parse(response.body)

      expect(result['description']).to eq(description)

      get '/api/v1/items/find?description=' + CGI.escape(description.titleize)

      result = JSON.parse(response.body)

      expect(result['description']).to eq('pickle')
    end

    it 'can find an item by description fragment' do
      description = 'The finest artisan friendship bracelets'
      create :item, description: description
      create :item

      get '/api/v1/items/find?description=friendship'

      result = JSON.parse(response.body)

      expect(result['description']).to eq(description)
    end

    it 'can find an item by unit price' do
      unit_price = 2000
      create :item, unit_price: unit_price
      create :item

      get '/api/v1/items/find?unit_price=' + unit_price.to_s

      result = JSON.parse(response.body)

      expect(result['unit_price'].to_i).to eq(unit_price)
    end

    it 'can find an item by created_at' do
      create :item, created_at: time
      create :item

      get '/api/v1/items/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      new_item = Item.find(result['id'])

      expect(new_item.created_at).to eq(time)
    end

    it 'can find an item by updated_at' do
      create :item, updated_at: time
      create :item

      get '/api/v1/items/find?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      new_item = Item.find(result['id'])

      expect(new_item.updated_at).to eq(time)
    end

    it 'can find all items by id' do
      create :item, id: 1
      create :item, id: 2

      get '/api/v1/items/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result.first['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all items by name' do
      create :item, name: 'boa'
      create :item, name: 'boa'
      create :item, name: 'panda'

      get '/api/v1/items/find_all?name=boa'

      result = JSON.parse(response.body)
      expect(result[0]['name']).to eq 'boa'
      expect(result[1]['name']).to eq 'boa'
      expect(result.count).to eq 2

      get '/api/v1/items/find_all?name=BOA'

      result = JSON.parse(response.body)
      expect(result[0]['name']).to eq 'boa'
      expect(result[1]['name']).to eq 'boa'
      expect(result.count).to eq 2
    end

    it 'can find all items by description' do
      description = 'I dont want to be creative'
      create :item, description: description
      create :item, description: description
      create :item, description: 'a different description'

      get '/api/v1/items/find_all?description=' + CGI.escape(description)

      result = JSON.parse(response.body)
      expect(result[0]['description']).to eq description
      expect(result[1]['description']).to eq description
      expect(result.count).to eq 2

      get '/api/v1/items/find_all?description=' + CGI.escape(description.titleize)

      result = JSON.parse(response.body)
      expect(result[0]['description']).to eq description
      expect(result[1]['description']).to eq description
      expect(result.count).to eq 2
    end

    it 'can find all items by description fragment' do
      description = 'I dont want to be creative'
      create :item, description: description
      create :item, description: description
      create :item, description: 'a different description'

      get '/api/v1/items/find_all?description=creative'

      result = JSON.parse(response.body)
      expect(result[0]['description']).to eq description
      expect(result[1]['description']).to eq description
      expect(result.count).to eq 2

      get '/api/v1/items/find_all?description=CREATiVe'

      result = JSON.parse(response.body)
      expect(result[0]['description']).to eq description
      expect(result[1]['description']).to eq description
      expect(result.count).to eq 2
    end

    it 'can find all items by unit_price' do
      unit_price = 2000
      create :item, unit_price: unit_price
      create :item, unit_price: unit_price
      create :item, unit_price: 2

      get '/api/v1/items/find_all?unit_price=' + unit_price.to_s

      result = JSON.parse(response.body)

      expect(result.first['unit_price']).to eq unit_price
      expect(result.last['unit_price']).to eq unit_price
      expect(result.count).to eq 2
    end

    it 'can find all items by created_at' do
      create :item, created_at: time, name: "BIG item"
      create :item, created_at: time, name: "ANOTHER item"
      create :item, created_at: time + 1, name: "HELLO"

      get '/api/v1/items/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      items = result.map do |item|
        Item.find(item['id'])
      end

      expect(items[0]['created_at']).to eq time
      expect(items[1]['created_at']).to eq time
      expect(items.count).to eq 2
    end

    it 'can find all items by updated_at' do
      create :item, updated_at: time
      create :item, updated_at: time
      create :item, updated_at: time + 1

      get '/api/v1/items/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      items = result.map do |item|
        Item.find(item['id'])
      end

      expect(items[0]['updated_at']).to eq time
      expect(items[1]['updated_at']).to eq time
      expect(items.count).to eq 2
    end

    it 'can return a random record' do
      item1 = create :item, name: 'shark'
      item2 = create :item, name: 'octoshark'
      item_names = [item1.name, item2.name]

      get '/api/v1/items/random'

      expect(response).to be_success

      result = JSON.parse(response.body)

      expect(item_names).to include(result['name'])

    end
  end
end
