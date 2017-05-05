class Api::V1::CustomersFavoriteMerchantController < ApplicationController
  def show
    render json: Merchant.top_merchant(params[:id])
  end
end
