class Api::V1::InvoicesController < ApplicationController

  def index
    return render json: Invoice.where(id: params[:id]) if params[:id]
    return render json: Invoice.where(status: params[:status]) if params[:status]
    return render json: Invoice.where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Invoice.where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
    return render json: Invoice.all
  end

  def show
    return render json: Invoice.find(params[:id]) if params[:id]
    return render json: Invoice.find_by(status: params[:status]) if params[:status]
    return render json: Invoice.find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Invoice.find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
    return render json: Invoice.order("RANDOM()").first if response.request.fullpath.include? 'random'
  end
end
