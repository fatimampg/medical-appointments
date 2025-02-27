class Address < ApplicationRecord
  belongs_to :user

  validates :street, :city, :country, presence: true
end
