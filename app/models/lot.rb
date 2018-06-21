class Lot < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: [:pending, :in_process, :closed]

  # Carriervawe uploader
  mount_uploader :image, ImageUploader
  
  # User have a lot
  belongs_to :user
  # lot have a bids
  has_many :bids, dependent: :destroy

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

  def self.sort_lots(sort_type)
    case sort_type
    when "created"
      @my_lots = current_user.lots
    when "participation"
      #@my_lots = Lot.includes(:bids).where(bids: {user_id: current_user.id})
      @my_lots = Lot.joins(:bids).where(bids: { user_id: current_user.id })
    else
      # if sort_type 'all' or other
      @my_lots = Lot.all
    end
    return @my_lots
  end

end
