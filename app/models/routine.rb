class Routine < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :users, through: :user_routines
  has_many :issue_routines, dependent: :destroy
  has_many :sleep_issues, through: :issue_routines
  has_many :sleep_records, dependent: :destroy

  validates :name, :description, :recommend_time, presence: true

  enum recommend_time: { before0: 0, before1: 1, before1_5: 15, before3: 3, before10: 10 }
end
