class Customer < ActiveRecord::Base
  before_save do
    first_name.downcase!
    last_name.downcase!
  end
  has_many :invoices
  has_many :transactions, through: :invoices
end
