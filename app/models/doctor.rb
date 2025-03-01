class Doctor < ApplicationRecord
  belongs_to :user
  has_many :doctors_specializations, dependent: :destroy
  has_many :specializations, through: :doctors_specializations
  has_many :appointments, dependent: :restrict_with_exception

  validates :firstname, presence: true, if: -> { user.present? && user.role == "doctor" }
  validates :firstname, presence: true, if: -> { user.present? && user.role == "doctor" }
end
