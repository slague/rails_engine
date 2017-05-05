class Api::V1::ItemsMostItemsController < ApplicationController
  def index
    render json: Item.most_items(params[:quantity].to_i || Item.count)
  end
end
