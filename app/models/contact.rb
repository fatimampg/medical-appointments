class Contact < ApplicationRecord
  belongs_to :user

  validates :number, presence: true
end
