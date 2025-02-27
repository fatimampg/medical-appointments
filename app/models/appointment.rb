class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validates :date, :time, presence: true
end
