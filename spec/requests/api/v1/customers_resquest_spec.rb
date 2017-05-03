require 'rails_helper'

describe 'Customers API' do
  context 'record end points' do
    attr_reader :time, :customers
    before do
      @cutomers = create_list(:customer, 2)
      @time = DateTime.new(2017, 5, 1, 20, 13, 20)
    end

    it 'sends all customers' do
      get '/api/v1/customers.json'

      expect(response).to be_success

      customers = JSON.parse response.body
      customer = customers.first

      expect(customers.count).to eq 2
      expect(customer['first_name']).to eq(customers.first.first_name)
      expect(customer['last_name']).to eq(customers.first.last_name)
      expect(customer).to_not have_key 'created_at'
      expect(customer).to_not have_key 'updated_at'
    end

    it 'can show one customer' do
      get "/api/v1/customers/#{customers.first.id}.json"

      expect(response).to be_success

      customer = JSON.parse(response.body)

      expect(customer['id']).to eq customer.id
      expect(customer['first_name']).to eq(customer.first_name)
      expect(customer['last_name']).to eq(customer.last_name)
      expect(customer).to_not have_key 'created_at'
      expect(customer).to_not have_key 'updated_at'
    end

    it 'can find a customer by id' do
      create :customer, id: 1
      get '/api/v1/customers/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find a customer by first name' do
      create :customer, first_name: 'Steph'
      get '/api/v1/customers/find?first_name=steph'

      result = JSON.parse(response.body)

      expect(result['first_name']).to eq('Steph')

      get '/api/v1/customers/find?first_name=Steph'
      result = JSON.parse(response.body)

      expect(result['first_name']).to eq('Steph')
    end

    it 'can find a customer by last name' do
      create :customer, last_name: 'Bentey'
      get '/api/v1/customers/find?last_name=Bentley'

      result = JSON.parse(response.body)

      expect(result['last_name']).to eq('Bentley')

      get '/api/v1/customers/find?last_name=bentley'

      result = JSON.parse(response.body)

      expect(result['last_name']).to eq('Bentley')
    end

    it 'can find a customer by created_at' do
      create :customer, created_at: time
      get '/api/v1/customers/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      customer1 = Customer.find(result['id'])

      expect(customer1.created_at).to eq(time)
    end

    it 'can find a customer by updated_at' do
      create :customer, updated_at: time
      get '/api/v1/customers/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      customer1 = Customer.find(result['id'])

      expect(customer1.updated_at).to eq(time)
    end

    it 'can find a random customer' do
      customer1 = create :customer
      customer2 = create :customer
      get '/api/v1/customers/random'

      expect(response).to be(success)

      response_customer = JSON.parse(response.body)

      if response_customer['id'] == customer1.id
        expect(response_customer.first_name).to eq(customer1.first_name)
        expect(response_customer.last_name).to eq(customer1.last_name)
      elsif response_customer['id'] == customer2.id
        expect(response_customer.first_name).to eq(customer2.first_name)
        expect(response_customer.last_name).to eq(customer2.last_name)
      else
        expect('uh oh').to eq('This should not happen')
      end
    end

    it 'can find all customers by id' do
      create :customer, id: 1
      create :customer, id: 2

      get '/api/v1/customers/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result[0]['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all customers by first name' do
      create :customer, first_name: 'Sam'
      create :customer, first_name: 'Sam'
      create :customer, first_name: 'Steph'

      get '/api/v1/customers/find_all?first_name=Sam'

      result = JSON.parse(response.body)
      expect(result[0]['first_name']).to eq 'Sam'
      expect(result[1]['first_name']).to eq 'Sam'
      expect(result.count).to eq 2
    end

    it 'can find all customers by last name' do
      create :customer, last_name: 'Sam'
      create :customer, last_name: 'Sam'
      create :customer, last_name: 'Steph'

      get '/api/v1/customers/find_all?last_name=Sam'

      result = JSON.parse(response.body)
      expect(result[0]['last_name']).to eq 'Sam'
      expect(result[1]['last_name']).to eq 'Sam'
      expect(result.count).to eq 2
    end

    it 'can find all customers by created_at' do
      create :customer, created_at: time
      create :customer, created_at: time
      create :customer, created_at: time + 1

      get '/api/v1/customers/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      customers = result.map do |customer|
        Customer.find(customer['id'])
      end

      expect(customers[0]['created_at']).to eq time
      expect(customers[1]['created_at']).to eq time
      expect(customers.count).to eq 2
    end
    it 'can find all customers by updated_at' do
      create :customer, updated_at: time
      create :customer, updated_at: time
      create :customer, updated_at: time + 1

      get '/api/v1/customers/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      customers = result.map do |customer|
        Customer.find(customer['id'])
      end

      expect(customers[0]['updated_at']).to eq time
      expect(customers[1]['updated_at']).to eq time
      expect(customers.count).to eq 2
    end
  end
end
