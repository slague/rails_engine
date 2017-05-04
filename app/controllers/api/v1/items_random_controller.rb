class Api::V1::ItemsRandomController < ApplicationController
  def show
    render json: Item.order("RANDOM()").first if response.request.fullpath.include? 'random'
  end
end
