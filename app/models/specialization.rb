class Specialization < ApplicationRecord
  has_many :doctors_specializations, dependent: :destroy
  has_many :doctors, through: :doctors_specializations
  has_many :appointments, dependent: :restrict_with_exception

  validates :name, presence: true
end
