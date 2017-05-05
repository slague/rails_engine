class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :transactions, through: :invoices

  def self.top_customer(merchant)
    Customer.find_by_sql("SELECT customers.*, count(transactions.invoice_id) AS count
                          FROM customers
                          JOIN invoices
                          ON invoices.customer_id = customers.id
                          JOIN transactions
                          ON transactions.invoice_id = invoices.id JOIN merchants ON invoices.merchant_id = merchants.id
                          WHERE transactions.result = 'success'
                          AND merchants.id = #{merchant}
                          GROUP BY customers.id ORDER BY count DESC;").first
  end

end
