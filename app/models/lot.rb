class Lot < ApplicationRecord
  enum status: [:pending, :in_process, :closed]
  # User have a lot
  belongs_to :user
end
