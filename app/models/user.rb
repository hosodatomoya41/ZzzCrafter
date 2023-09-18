class User < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :routines, through: :user_routines
  has_many :sleep_issues, dependent: :destroy
  has_many :sleep_records, dependent: :destroy
  
  validates :line_user_id, presence: true, uniqueness: true
  
end
