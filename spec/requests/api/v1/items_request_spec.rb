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
      expect(items.first).to_not have_key 'created_at'
      expect(items.first).to_not have_key 'updated_at'
    end
  end
end