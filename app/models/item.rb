class Item < ActiveRecord::Base
  before_save do
    description.downcase!
  end
  validates :name, :description, :unit_price, presence: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
end
