class RoutinesController < ApplicationController
  def index
    @routines_before0 = Routine.where(recommend_time: 'before0')
    @routines_before1 = Routine.where(recommend_time: 'before1')
    @routines_before3 = Routine.where(recommend_time: ['before3', 'before10'])
  end
  
  def show
    @routine = Routine.find(params[:id])
  end
end
