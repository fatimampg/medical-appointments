class Patient < ApplicationRecord
  belongs_to :user
  has_many :appointments, dependent: :restrict_with_exception

  validates :firstname, :surname, presence: true
end
