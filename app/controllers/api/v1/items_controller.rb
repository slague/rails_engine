class Api::V1::ItemsController < ApplicationController
  def index
    return render json: Item.where(id: params[:id]) if params[:id]
    return render json: Item.where(name: (params[:name]).downcase) if params[:name]
    return render json: Item.where(unit_price: params[:unit_price]) if params[:unit_price]
    return render json: Item.where(description: params[:description]) if params[:description]
    return render json: Item.where(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Item.where(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
    return render json: Item.all
  end

  def show
    return render json: Item.find(params[:id]) if params[:id]
    return render json: Item.find_by(name: (params[:name]).downcase) if params[:name]
    return render json: Item.find_by(unit_price: params[:unit_price]) if params[:unit_price]
    return render json: Item.find_by(description: params[:description]) if params[:description]
    return render json: Item.find_by(created_at: params[:created_at].to_datetime) if params[:created_at]
    return render json: Item.find_by(updated_at: params[:updated_at].to_datetime) if params[:updated_at]
    return render json: Item.order("RANDOM()").first if response.request.fullpath.include? 'random'
  end
end
