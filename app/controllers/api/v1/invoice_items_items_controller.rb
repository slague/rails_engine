class Api::V1::InvoiceItemsItemsController < ApplicationController

  def show
    render json: InvoiceItem.find(params[:id]).item
  end
end
