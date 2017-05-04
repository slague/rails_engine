class Item < ActiveRecord::Base
  before_save do
    description.downcase!
  end
  validates :name, :description, :unit_price, presence: true

  belongs_to :merchant
end
