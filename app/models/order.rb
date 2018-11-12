class Order < ApplicationRecord
  enum arrival_status: [:pending, :sent, :delivered]
  enum arrival_type: {"pickup" => 0, "Royal Mail" => 1, "United States Postal Service" => 2, "DHC Express" => 3}

  # order have just one winning bid
  belongs_to :lot

  validates :arrival_location, :arrival_status, :arrival_type, presence: true

  after_create :send_create_order_email
  after_update :send_sent_order_email, :if => :order_sent?
  after_update :send_delivered_order_email, :if => :order_delivered?

  def order_sent?
    self.sent?
  end

  def order_sent?
    self.delivered?
  end

  def send_create_order_email
    SellerMailer.order_create_email(self).deliver_later    
  end

  def send_sent_order_email
    CustomerMailer.order_sent_email(self).deliver_later    
  end

  def send_delivered_order_email
    SellerMailer.order_delivered_email(self).deliver_later    
  end

end
