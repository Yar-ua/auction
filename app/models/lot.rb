class Lot < ApplicationRecord
  enum status: [:pending, :in_process, :closed]
  # User have a lot
  belongs_to :user

  # Set validation
  validates :title, :current_price, :estimated_price, :lot_start_time, 
    :lot_end_time, presence: {message: 'Value must be present'}
  validates :current_price, :estimated_price, numericality: { only_integer: false, message: 'Value must be digit' }
  validates_datetime :lot_start_time, :lot_end_time
  # TODO
  # need to add validation of price (>0) and datetime (more than current time, 
  # endtime > starttime)
end
