class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :patient, dependent: :destroy
  has_one :doctor, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :contacts, dependent: :destroy

  enum role: { admin: 0, patient: 1, doctor: 2 }
end
