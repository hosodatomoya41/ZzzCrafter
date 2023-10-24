# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :routines, through: :user_routines
  has_many :sleep_records, dependent: :destroy
  belongs_to :sleep_issue, optional: true

  validates :line_user_id, presence: true, uniqueness: true
end
