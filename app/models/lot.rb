class Lot < ApplicationRecord
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

  after_create :create_jobs
  before_update :update_jobs
  # before_destroy :delete_jobs

  def price_right_difference
    if ( estimated_price > current_price )
      return true 
    end
  end

  def self.sort_lots(sort_type, user)
    case sort_type
    when "created"
      @my_lots = user.lots
    when "participation"
      @my_lots = Lot.joins(:bids).where(bids: { user_id: user.id })
    else
      @my_lots = Lot.left_joins(:bids).where("lots.user_id = ? OR bids.user_id = ?", user.id, user.id)
    end
    return @my_lots
  end

  def create_jobs
    jid_in_process = create_job(lot_start_time, id, :in_process)
    jid_closed = create_job(lot_end_time, id, :closed)
    update_columns(jid_in_process: jid_in_process, jid_closed: jid_closed)
  end

  def create_job(time, lot_id, status)
    return JobWorker.perform_at(time, lot_id, status)
  end

  def update_jobs
    if lot_start_time_changed?
      jid_in_process = create_job(lot_start_time, id, :in_process)
      update_column(:jid_in_process, jid_in_process)
    end

    if lot_end_time_changed?
      jid_closed = create_job(lot_end_time, id, :closed)
      update_column(:jid_closed, jid_closed)
    end
  end

end
