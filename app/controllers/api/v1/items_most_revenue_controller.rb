class Api::V1::ItemsMostRevenueController < ApplicationController
  def index
    render json: Item.most_revenue(params['quantity'].to_i) if params['quantity']
  end
end
