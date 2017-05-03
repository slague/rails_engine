class Api::V1::TransactionsController < ApplicationController
  def show
    return render json: Transaction.order('RANDOM()').first if response.request.fullpath.include? 'random'

    render json: Transaction.find(params[:id])
  end

  def index
    render json: Transaction.all
  end
end
