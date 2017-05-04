class Invoice < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items
  has_many :transactions

  validates :status, :created_at, :updated_at, presence: true
end
