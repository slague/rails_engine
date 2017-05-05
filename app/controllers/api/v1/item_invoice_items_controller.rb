class Api::V1::ItemInvoiceItemsController < ApplicationController

  def index
    render json: Item.find(params[:id]).invoice_items
  end
end
