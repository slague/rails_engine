require 'rails_helper'

describe 'Merchants API' do
  it 'sends all merchants' do
    create_list(:merchant, 2)

    get '/api/v1/merchants.json'

    expect(response).to be_success

    merchants = JSON.parse response.body
    merchant = merchants.first

    expect(merchants.count).to eq 2
    expect(merchant['name']).to eq 'Merchant #1'
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
end
