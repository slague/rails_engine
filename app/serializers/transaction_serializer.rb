class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :credit_card_number, :result, :invoice_id

  def credit_card_number
    object.credit_card_number.to_s
  end
end
