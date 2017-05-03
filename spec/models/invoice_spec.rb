require 'rails_helper'

RSpec.describe Invoice do
  attr_reader :time, :merchant, :customer, :invoice

  before do
    @time = DateTime.new(2017, 5, 1, 20, 13, 20)
    @merchant = create :merchant
    @customer = create :customer
    @invoice = Invoice.new(status: 'success',
                           created_at: time,
                           updated_at: time,
                           merchant_id: merchant.id,
                           customer_id: customer.id)
  end

  context 'validations' do
    it 'is valid with a status, created_at, and updated_at' do
      expect(invoice).to be_valid
    end

    it 'is invalid without a status' do
      invoice1 = Invoice.new(created_at: time,
                             updated_at: time,
                             merchant_id: merchant.id,
                             customer_id: customer.id)

      expect(invoice1).to_not be_valid
    end

    it 'is invalid without created_at' do
      invoice2 = Invoice.new(status: 'success',
                             updated_at: time,
                             merchant_id: merchant.id,
                             customer_id: customer.id)

      expect(invoice2).to_not be_valid
    end

    it 'is invalid without updated_at' do
      invoice3 = Invoice.new(status: 'success',
                             created_at: time,
                             merchant_id: merchant.id,
                             customer_id: customer.id)

      expect(invoice3).to_not be_valid
    end
  end

  context 'relationships' do
    it 'has a merchant' do
      expect(invoice.merchant).to eq(merchant)
    end

    it 'has a customer' do
      expect(invoice.customer).to eq(customer)
    end
  end
end
