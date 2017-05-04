class Api::V1::InvoiceItemsRandomController < ApplicationController

  def show
    render json: InvoiceItem.order("RANDOM()").first
  end
end
