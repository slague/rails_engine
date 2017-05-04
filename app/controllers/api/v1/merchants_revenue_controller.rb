class Api::V1::MerchantsRevenueController < ApplicationController
  def index
    render json: Merchant.order_by_revenue(params[:quantity].to_i)
  end

  def show
    render json: Merchant.find(params[:id]), date: params[:date]
  end
end
