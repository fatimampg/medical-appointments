class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :specialization

  validates :time, presence: true
end
