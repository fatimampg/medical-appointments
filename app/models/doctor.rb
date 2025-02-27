class Doctor < ApplicationRecord
  belongs_to :user
  has_many :doctors_specializations, dependent: :destroy
  has_many :specializations, through: :doctors_specializations
  has_many :appointments

  validates :firstname, :surname, presence: true
end
