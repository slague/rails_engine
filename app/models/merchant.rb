class Merchant < ActiveRecord::Base
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices

  validates :name, :created_at, :updated_at, presence: true

  def revenue(date = nil)
    invoices = date ? self.invoices.where("DATE(invoices.created_at) = ?", date) : self.invoices
    rev = invoices.joins(:transactions).where('transactions.result = ?', 'success').joins(:invoice_items).sum('invoice_items.quantity * invoice_items.unit_price')
    num_to_currency(rev)
  end

  def valid_invoice_items
    invoice_items.joins('JOIN transactions ON invoices.id = transactions.invoice_id').where(transactions: {result: 'success'})
  end

  def self.order_by_revenue(quantity = Merchant.count)
    self.joins(:invoices).joins('JOIN transactions ON invoices.id = transactions.invoice_id').where('transactions.result = ?', 'success').joins('JOIN invoice_items ON invoice_items.invoice_id = invoices.id').group('merchants.id').order('SUM(invoice_items.quantity * invoice_items.unit_price) DESC').limit(quantity)
  end

  def self.revenue_on_day(date)
    rev = self.joins(:invoices).where("DATE(invoices.created_at) = ?", date).joins('JOIN transactions ON invoices.id = transactions.invoice_id').where('transactions.result = ?', 'success').joins('JOIN invoice_items ON invoice_items.invoice_id =
    	invoices.id').sum('invoice_items.quantity * invoice_items.unit_price')
    self.num_to_currency(rev)
  end

  def self.most_items(quantity = Merchant.count)
    Merchant.find_by_sql("SELECT merchants.*, sum(invoice_items.quantity) AS total_items
                          FROM merchants JOIN invoices ON merchants.id = invoices.merchant_id
                          JOIN transactions ON transactions.invoice_id = invoices.id
                          JOIN invoice_items ON invoices.id = invoice_items.invoice_id
                          WHERE transactions.result = 'success'
                          GROUP BY merchants.id ORDER BY total_items DESC;").first(quantity)
  end


  def self.top_merchant(customer)
    Merchant.find_by_sql("SELECT merchants.*, count(transactions.invoice_id) AS count
                          FROM merchants
                          JOIN invoices
                          ON invoices.merchant_id = merchants.id
                          JOIN transactions
                          ON transactions.invoice_id = invoices.id JOIN customers ON invoices.customer_id = customers.id
                          WHERE transactions.result = 'success'
                          AND customers.id = #{customer}
                          GROUP BY merchants.id ORDER BY count DESC;").first
  end

  private

  def self.num_to_currency(num)
    sprintf '%.2f', num / 100.0
  end

  def num_to_currency(num)
    sprintf '%.2f', num / 100.0
  end
end
