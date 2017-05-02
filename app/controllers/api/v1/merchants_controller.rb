class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id]) if params[:id]
    render json: Merchant.find_by(name: params[:name]) if params[:name]
    render json: Merchant.find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    render json: Merchant.find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end
end