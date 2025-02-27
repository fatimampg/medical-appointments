class Specialization < ApplicationRecord
  has_many :doctors_specializations, dependent: :destroy
  has_many :doctors, through: :doctors_specializations

  validates :name, presence: true
end
