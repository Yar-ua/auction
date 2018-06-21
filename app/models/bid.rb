class Bid < ApplicationRecord
  has_one :order, dependent: :destroy
  belongs_to :lot
  belongs_to :user

  validates :proposed_price, presence: true
  validates :proposed_price, numericality: { only_integer: false, message: 'Value must be digit' }
  validates :proposed_price, numericality: { :greater_than_or_equal_to => 0 }

  before_create :proposed_price_is_valid

  after_create :update_lot_current_price
  after_create :check_is_winner

  def update_lot_current_price
    self.lot.current_price = proposed_price
    self.lot.save
  end

  def proposed_price_is_valid
    self.lot.current_price < proposed_price
  end

  def check_is_winner
    if self.lot.estimated_price <= proposed_price
      self.is_winner = true
      self.save
      # method closed! update all data changed in object, is_winner it update too
      self.lot.closed!
    end
  end

end
