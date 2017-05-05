class Api::V1::InvoiceCustomersController < ApplicationController

  def show
    render json: Invoice.find(params[:id]).customer
  end
end
