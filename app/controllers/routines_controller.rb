class RoutinesController < ApplicationController
  def index
    @routines = Routine.all
  end
end
