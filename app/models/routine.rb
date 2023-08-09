class Routine < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :users, through: :user_routines
  has_many :issue_routines, dependent: :destroy
  has_many :sleep_records, dependent: :destroy

  validates :name, :description, :recommend_time, presence: true
end
