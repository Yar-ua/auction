class Lot < ApplicationRecord
  enum status: [:pending, :in_process, :closed]
  # User have a lot
  belongs_to :user

  # Set validation
  validates :title, :current_price, :estimated_price, :lot_start_time, 
    :lot_end_time, presence: {message: 'Value must be present'}
  validates :current_price, :estimated_price, numericality: { only_integer: false, message: 'Value must be digit' }
  validates :current_price, :estimated_price, numericality: { :greater_than_or_equal_to => 0 }
  validates_datetime :lot_end_time, :after => :lot_start_time
  validate :price_right_difference

  def price_right_difference
    if ( estimated_price > current_price )
      return true 
    end
  end

end
