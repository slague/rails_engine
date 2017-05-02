require 'rails_helper'

describe 'Merchants API' do
  it 'sends all merchants' do
    create_list(:merchant, 2)

    get 'api/v1/merchants.json'

    expect(response).to be_success

    merchants = JSON.parse response.body
    merchant = merchants.first

    expect(merchants.count).to eq 2
    expect(merchant['name']).to eq 'Merchant #1'
    expect(merchant['created_at']).to be DateTime
    expect(merchant['updated_at']).to be DateTime
  end
end
