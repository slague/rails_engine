class Api::V1::MerchantsRevenueController < ApplicationController
  def index
    render json: Merchant.order_by_revenue(params[:quantity].to_i) if params[:quantity]
    render json: Merchant.revenue_on_day(params[:date]) if params[:date]
  end

  def show
    render json: Merchant.find(params[:id]), date: params[:date]
  end
end
