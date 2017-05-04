class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices

  validates :name, :created_at, :updated_at, presence: true


  def revenue(date = nil)
    invoices = date ? self.invoices.where("DATE(invoices.created_at) = ?", date) : self.invoices
    rev = invoices.joins(:transactions).where('transactions.result = ?', 'success').joins(:invoice_items).sum('invoice_items.quantity * invoice_items.unit_price')
    num_to_currency(rev)
  end

  def self.order_by_revenue(quantity = Merchant.count)
    self.joins(:invoices).joins('JOIN transactions ON invoices.id = transactions.invoice_id').where('transactions.result = ?', 'success').joins('JOIN invoice_items ON invoice_items.invoice_id = invoices.id').group('merchants.id').order('SUM(invoice_items.quantity * invoice_items.unit_price) DESC').limit(quantity)
  end

  def self.revenue_on_day(date)
    rev = self.joins(:invoices).where("DATE(invoices.created_at) = ?", date).joins('JOIN transactions ON invoices.id = transactions.invoice_id').where('transactions.result = ?', 'success').joins('JOIN invoice_items ON invoice_items.invoice_id =
    	invoices.id').sum('invoice_items.quantity * invoice_items.unit_price')
    self.num_to_currency(rev)
  end

  private

  def self.num_to_currency(num)
    sprintf '%.2f', num / 100.0
  end

  def num_to_currency(num)
    sprintf '%.2f', num / 100.0
  end
end
