class Api::V1::InvoiceItemsInvoicesController < ApplicationController

  def show
    render json: InvoiceItem.find(params[:id]).invoice
  end
end
