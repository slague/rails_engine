class Api::V1::MerchantsController < ApplicationController
  def index
    return render json: Merchant.where(id: params[:id]) if params[:id]
    return render json: Merchant.where(name: params[:name]) if params[:name]
    return render json: Merchant.where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Merchant.where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
    return render json: Merchant.all
  end

  def show
    return render json: Merchant.find(params[:id]) if params[:id]
    return render json: Merchant.find_by(name: params[:name]) if params[:name]
    return render json: Merchant.find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Merchant.find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
  end
end