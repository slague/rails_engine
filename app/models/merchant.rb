class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  validates :name, :created_at, :updated_at, presence: true

  def revenue
    invoices.joins(:invoice_items).sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
