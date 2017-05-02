require 'rails_helper'


describe 'Item API' do
  context 'record end points' do
    attr_reader :item1, :item2
    before do
      @item1, @item2 = create_list(:item, 2)
    end

    it 'returns all items' do
      get 'api/v1/items'
      expect(response).to be_success

      items = JSON.parse(response.body)
      expect(items.first).to eq(item1.to_h)
    end
  end
end