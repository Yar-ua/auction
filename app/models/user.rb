class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable #, :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Set validations
  validates :phone, :email, uniqueness: true
  validates :email, :phone, :first_name, :last_name, :birth_day, presence: true, uniqueness: true
  validates :password, length: { in: 6..20 }
  validates :phone, numericality: { only_integer: true }
  validates :first_name, :last_name, length: { maximum: 30 }

end
