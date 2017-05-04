class MerchantSerializer < ActiveModel::Serializer
  attributes :id, :name, :revenue

  def revenue
    object.revenue(@instance_options[:date])
  end
end
