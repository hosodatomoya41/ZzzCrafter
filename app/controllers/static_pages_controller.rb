class StaticPagesController < ApplicationController
  def top
    @routine = Routine.find(5)
  end
end
