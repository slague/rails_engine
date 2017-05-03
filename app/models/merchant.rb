class Merchant < ActiveRecord::Base
  has_many :items

  validates :name, :created_at, :updated_at, presence: true
end
