class Api::V1::CustomersRandomController < ApplicationController
  def show
    render json: Customer.order('RANDOM()').first
  end
end
