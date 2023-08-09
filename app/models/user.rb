class User < ApplicationRecord
  authenticates_with_sorcery!
  class user < applicationrecord
  has_many :routines, through: :user_routines
  has_many :user_routines, dependent: :destroy
  has_many :sleep_issues, dependent: :destroy
  has_many :sleep_records, dependent: :destroy
  
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true
end
end
