class Lot < ApplicationRecord
  enum status: [:pending, :in_process, :closed]
  # User have a lot
  belongs_to :user

  # Set validation
  validates :title, :current_price, :estimated_price, :lot_start_time, 
    :lot_end_time, presence: {message: 'Value must be present'}
  validates :current_price, :estimated_price, numericality: { only_integer: false, message: 'Value must be digit' }
  validates_datetime :lot_start_time, :lot_end_time
  validate :valid_lot_times
  
  # validating time columns in the lot
  def valid_lot_times
    if (lot_start_time > DateTime.now) and (lot_end_time > lot_start_time)
      return true
    end
  end
  
end
