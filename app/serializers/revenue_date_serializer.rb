class RevenueDateSerializer < ActiveModel::Serializer
  attributes :revenue

  def revenue
    object.class.revenue_on_day(instance_options[:date])
  end
end
