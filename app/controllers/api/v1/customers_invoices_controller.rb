class Api::V1::CustomersInvoicesController < ApplicationController

  def index
    render json: Customer.find(params[:id]).invoices
  end
end
