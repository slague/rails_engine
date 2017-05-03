class Api::V1::TransactionFindController < ApplicationController
  def index
    render json: Transaction.where(transaction_params)
  end

  private

  def transaction_params
    params[:created_at] = params[:created_at].to_datetime if params[:created_at]
    params[:updated_at] = params[:updated_at].to_datetime if params[:updated_at]
    params.permit(:id, :invoice_id, :credit_card_number, :result, :created_at, :updated_at)
  end
end
