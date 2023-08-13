class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :routines, through: :user_routines
  has_many :user_routines, dependent: :destroy
  has_many :sleep_issues, dependent: :destroy
  has_many :sleep_records, dependent: :destroy
  
  validates :name, :email,  presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
