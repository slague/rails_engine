class Api::V1::MerchantsRevenueController < ApplicationController
  def index
    render json: Merchant.order_by_revenue(params[:quantity].to_i) if params[:quantity]
    render json: {total_revenue: Merchant.revenue_on_day(params[:date])} if params[:date]
  end

  def show
    if params[:date]
      render json: Merchant.find(params[:id]), serializer: RevenueDateSerializer, date: params[:date]
    else
      render json: Merchant.find(params[:id]), serializer: RevenueSerializer
    end
  end
end
