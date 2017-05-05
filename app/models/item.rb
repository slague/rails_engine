class Item < ActiveRecord::Base
  before_save do
    description.downcase!
  end
  validates :name, :description, :unit_price, presence: true

  belongs_to :merchant
  has_many :invoice_items

  def self.most_items(quantity = Item.count)
    Item.find_by_sql("SELECT items.*, sum(invoice_items.quantity) AS total_items
                      FROM items JOIN invoice_items ON items.id = invoice_items.item_id
                      JOIN transactions ON transactions.invoice_id = invoice_items.invoice_id
                      WHERE transactions.result = 'success'
                      GROUP BY items.id ORDER BY total_items DESC;").first(quantity)
  end

  def valid_invoice_items
    invoice_items.joins('JOIN invoices ON invoices.id = invoice_items.invoice_id JOIN transactions ON invoices.id = transactions.invoice_id').where(transactions: {result: 'success'})
  end
end
