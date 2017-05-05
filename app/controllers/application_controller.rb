class ApplicationController < ActionController::API
  def clean_params
    params[:created_at] = params[:created_at].to_datetime if params[:created_at]
    params[:updated_at] = params[:updated_at].to_datetime if params[:updated_at]
    params[:unit_price] = (params[:unit_price].to_f * 100).round.to_i if params[:unit_price]
    params[:status].downcase! if params[:status]
    params[:result].downcase! if params[:result]
    params
  end
end
