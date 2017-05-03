require 'rails_helper'

describe 'Transactions API' do
  context 'record end points' do

    attr_reader :transactions, :time
    before do
      @transactions = create_list(:transaction, 2)
      @time = DateTime.new(2017,5,1,20,13,20)
    end

    it 'sends all transactions' do
	    get '/api/v1/transactions.json'

	    expect(response).to be_success

	    transaction= JSON.parse response.body
	    transaction = transactions.first
	    transaction2 = transactions.last

	    expect(transactions.count).to eq 2

	    expect(transaction['result']).to eq transactions.first.result
	    expect(transaction['credit_card_number']).to eq transactions.first.credit_card_number
	    expect(transaction).to_not have_key 'created_at'
	    expect(transaction).to_not have_key 'updated_at'


	    expect(transaction2['result']).to eq transactions.last.result
	    expect(transaction2['credit_card_number']).to eq transactions.last.credit_card_number
	    expect(transaction2).to_not have_key 'created_at'
	    expect(transaction2).to_not have_key 'updated_at'
    end

    it 'returns one transaction' do

	    get "/api/v1/transactions/#{transactions.first.id}.json"

	    expect(response).to be_success

	    response_transaction = JSON.parse response.body

	    expect(response_transaction['id']).to eq transaction.id
	    expect(response_transaction['result']).to eq transaction.result
	    expect(response_transaction['credit_card_number']).to eq transaction.result
	    expect(response_transaction).to_not have_key 'created_at'
	    expect(response_transaction).to_not have_key 'updated_at'
	  end


    it 'can find a transaction by id' do
      create :transaction, id: 1
      get '/api/v1/transactions/find?id=1'

      result = JSON.parse(response.body)

      expect(result['id']).to eq(1)
    end

    it 'can find a transaction by credit card number' do
      create :transaction, credit_card_number: 4654405418249632
      get '/api/v1/transactions/find?credit_card_number=4654405418249632'

      result = JSON.parse(response.body)

      expect(result['credit_card_number']).to eq(4654405418249632)
    end

    it 'can find a transaction by result' do
      create :transaction, result: 'success'
      get '/api/v1/transactions/find?result=success'

      result = JSON.parse(response.body)

      expect(result['result']).to eq('success')

      get '/api/v1/transactions/find?result=Success'

      result = JSON.parse(response.body)

      expect(result['result']).to eq('success')
    end

    it 'can find a transaction by created_at' do
      create :transaction, created_at: time
      get '/api/v1/transactions/find?created_at=' + time.to_s

      result = JSON.parse(response.body)
      transaction1 = Transaction.find(result['id'])

      expect(transaction1.created_at).to eq(time)
    end

    it 'can find a transaction by updated_at' do
      create :transaction, updated_at: time
      get '/api/v1/transactions/find?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      transaction1 = Transaction.find(result['id'])

      expect(transaction1.updated_at).to eq(time)
    end

    it 'can find a random transaction' do
      transaction1 = create :transaction
      transaction2 = create :transaction
      get '/api/v1/transactions/random'

      expect(response).to be(success)

      response_transaction = JSON.parse(response.body)

      if response_transaction['id'] == transaction1.id
        expect(response_transaction.result).to eq(transaction1.result)
        expect(response_transaction.credit_card_number).to eq(transaction1.credit_card_number)
      elsif response_transcation['id'] == transaction2.id
        expect(response_transaction.result).to eq(transaction2.result)
        expect(response_transaction.credit_card_number).to eq(transaction2.credit_card_number)
      else
        expect('uh oh').to eq('This should not happen')
      end
    end

    it 'can find all transactions by id' do
      create :transaction, id: 1
      create :transaction, id: 2

      get '/api/v1/transations/find_all?id=1'

      result = JSON.parse(response.body)
      expect(result[0]['id']).to eq 1
      expect(result.count).to eq 1
    end

    it 'can find all transactions by credit card number' do
      create :transaction, credit_card_number: 4654405418249632
      create :transaction, credit_card_number: 4654405418249632
      create :transaction, credit_card_number: 4654405418249610

      get '/api/v1/transactions/find_all?credit_card_number=4654405418249632'

      result = JSON.parse(response.body)
      expect(result[0]['credit_card_number']).to eq 4654405418249632
      expect(result[1]['credit_card_number']).to eq 4654405418249632
      expect(result.count).to eq 2
    end

    it 'can find all transactions by result' do
      create :transaction, result: 'success'
      create :transaction, result: 'success'
      create :transaction, result: 'failed'

      get '/api/v1/transactions/find_all?result=success'

      result = JSON.parse(response.body)
      expect(result[0]['result']).to eq('succes')
      expect(result[1]['result']).to eq('succes')
      expect(result.count).to eq 2
    end

    it 'can find all transactions by created_at' do
      create :transaction, created_at: time
      create :transaction, created_at: time
      create :transaction, created_at: time + 1

      get '/api/v1/transactions/find_all?created_at=' + time.to_s

      result = JSON.parse(response.body)
      transactions_array = result.map do |transaction|
        Transaction.find(transaction['id'])
      end

      expect(transactions_array[0]['created_at']).to eq time
      expect(transactions_array[1]['created_at']).to eq time
      expect(transactions_array.count).to eq 2
    end

    it 'can find all transactions by updated_at' do
      create :transaction, updated_at: time
      create :transaction, updated_at: time
      create :transaction, updated_at: time + 1

      get '/api/v1/transactions/find_all?updated_at=' + time.to_s

      result = JSON.parse(response.body)
      transactions_array = result.map do |transaction|
        Transaction.find(transaction['id'])
      end

      expect(transactions_array[0]['updated_at']).to eq time
      expect(transactions_array[1]['updated_at']).to eq time
      expect(transactions_array.count).to eq 2
    end
  end
end
