class Api::V1::TransactionInvoicesController < ApplicationController

  def show
    render json: Transaction.find(params[:id]).invoice
  end
end
