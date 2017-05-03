class Item < ActiveRecord::Base
  validates :name, :description, :unit_price, presence: true
  validates_uniqueness_of :name

  belongs_to :merchant
end