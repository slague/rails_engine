class Api::V1::InvoiceMerchantsController < ApplicationController

  def show
    render json: Invoice.find(params[:id]).merchant
  end
end
