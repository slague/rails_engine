class Merchant < ActiveRecord::Base
  has_many :items

  validates :name, :created_at, :updated_at, presence: true
  validates_uniqueness_of :name
end
