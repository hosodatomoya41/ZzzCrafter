# frozen_string_literal: true

class UserRoutine < ApplicationRecord
  belongs_to :user
  belongs_to :routine

  validates :user_id, :routine_id, :choose_date, presence: true

def self.grouped_by_date(year, month, user_id)
  start_date = Date.new(year, month, 1)
  end_date = start_date.end_of_month
  where(user_id: user_id, choose_date: start_date..end_date)
    .order('choose_date DESC')
    .group_by(&:choose_date)
end

end
