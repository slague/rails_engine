class Api::V1::InvoiceItemsRelationshipController < ApplicationController

  def index
    render json: Invoice.find(params[:id]).items
  end
end
