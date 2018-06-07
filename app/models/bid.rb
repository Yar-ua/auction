class Bid < ApplicationRecord
  has_one :order, dependent: :destroy
  belongs_to :lot
  belongs_to :user

  validates :proposed_price, presence: true
  validates :proposed_price, numericality: { only_integer: false, message: 'Value must be digit' }
  validates :proposed_price, numericality: { :greater_than_or_equal_to => 0 }
end
