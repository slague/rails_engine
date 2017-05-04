class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  validates :name, :created_at, :updated_at, presence: true

  def revenue
    invoices.joins(:transactions).where('transactions.result = ?', 'success').joins(:invoice_items).sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.order_by_revenue(quantity = Merchant.count)
    self.joins(:invoices).joins('JOIN transactions ON invoices.id = transactions.invoice_id').where('transactions.result = ?', 'success').joins('JOIN invoice_items ON invoice_items.invoice_id = invoices.id').group('merchants.id').order('SUM(invoice_items.quantity * invoice_items.unit_price) DESC').limit(quantity)
  end
end
