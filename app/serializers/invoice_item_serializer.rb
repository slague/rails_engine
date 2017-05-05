class InvoiceItemSerializer < ActiveModel::Serializer
  attributes :id, :unit_price, :quantity, :invoice_id, :item_id

  def unit_price
    sprintf '%.2f', object.unit_price / 100.0
  end
end
