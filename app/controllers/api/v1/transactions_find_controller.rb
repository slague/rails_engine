class Api::V1::TransactionsFindController < ApplicationController
  def index
    render json: Transaction.where(transaction_params)
  end

  def show
    render json: Transaction.find_by(transaction_params)
  end
end
