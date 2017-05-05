class Api::V1::ItemMerchantsController < ApplicationController

  def show
    render json: Item.find(params[:id]).merchant
  end
end
