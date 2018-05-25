class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable #, :omniauthable
  include DeviseTokenAuth::Concerns::User

  # User can have many Lots
  has_many :lots, dependent: :destroy

  # Set validations
  validates :phone, :email, uniqueness: {message: 'Current phone or email already exists, try another'}
  validates :email, :phone, :first_name, :last_name, :birth_day, presence: {messaage: 'Value must be present'}
  validates :first_name, :last_name, length: { maximum: 30 , message: 'Max length must be 30 symbols'}
  
  # validate, what user age 21 year or more
  validate :user_age

  
  # check user's current age
  def user_age
  	errors.add(:birth_day, "Your age must be 21 years or more") if
  	  (Date.today.year - self.birth_day.to_i) <= 21
  end

end
