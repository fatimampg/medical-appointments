class Patient < ApplicationRecord
  belongs_to :user
  has_many :appointments

  validates :firstname, :surname, presence: true
end
