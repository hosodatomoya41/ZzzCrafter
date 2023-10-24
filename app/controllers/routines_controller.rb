# frozen_string_literal: true

class RoutinesController < ApplicationController
  def index
    @routines_before0 = Routine.where(recommend_time: 'before0')
    @routines_before1 = Routine.where(recommend_time: %w[before1 before1_5])
    @routines_before3 = Routine.where(recommend_time: %w[before3 before10])
  end

  def show
    @routine = Routine.find(params[:id])
  end
end
