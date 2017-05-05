class Api::V1::MerchantsFavoriteCustomerController < ApplicationController
  def show
    render json: Customer.top_customer(params[:id])
  end
end
