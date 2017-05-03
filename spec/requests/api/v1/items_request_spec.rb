require 'rails_helper'

describe 'Item API' do
  context 'record end points' do
    attr_reader :item1, :item2, :merchant

    before do
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
  end
end
