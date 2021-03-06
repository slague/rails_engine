class Api::V1::InvoiceItemsFindController < ApplicationController

  def index
    render json: InvoiceItem.where(invoice_item_params)
  end

  def show
    render json: InvoiceItem.find_by(invoice_item_params)
  end


  def invoice_item_params
      params = clean_params
      params.permit(:id, :invoice_id, :item_id, :quantity, :unit_price, :created_at, :updated_at, :invoice_id, :item_id)
  end
end
