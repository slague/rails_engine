class ApplicationController < ActionController::API
  def clean_params
    params[:created_at] = params[:created_at].to_datetime if params[:created_at]
    params[:updated_at] = params[:updated_at].to_datetime if params[:updated_at]
    params[:name].downcase! if params[:name]
    params[:first_name].downcase! if params[:first_name]
    params[:last_name].downcase! if params[:last_name]
    params[:description].downcase! if params[:description]
    params[:status].downcase! if params[:status]
    params[:result].downcase! if params[:result]
    params
  end
end
