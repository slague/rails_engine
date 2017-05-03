class Item < ActiveRecord::Base
  validates :name, :description, :unit_price, presence: true

  belongs_to :merchant
end
