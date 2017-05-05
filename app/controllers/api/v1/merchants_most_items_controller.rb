class Api::V1::MerchantsMostItemsController < ApplicationController
  def index
    render json: Merchant.most_items(params[:quantity].to_i || Merchant.count)
  end
end
