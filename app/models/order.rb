class Order < ApplicationRecord
  enum arrival_status: [:pending, :sent, :delivered]
  enum arrival_type: {"pickup" => 0, "Royal Mail" => 1, "United States Postal Service" => 2, "DHC Express" => 3}

  # order have just one winning bid
  belongs_to :lot

  validates :arrival_location, :arrival_status, :arrival_type, presence: true

end
