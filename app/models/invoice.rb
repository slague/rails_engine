class Invoice < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items

  validates :status, :created_at, :updated_at, presence: true
end
