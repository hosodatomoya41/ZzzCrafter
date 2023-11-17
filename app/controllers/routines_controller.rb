# frozen_string_literal: true

class RoutinesController < ApplicationController
  def index
    if session[:user_id].present?
    user = User.find(session[:user_id])
    initialize_issue_type(user)
    initialize_routines(user)
    else
      @routines = Routine.all
      set_routines
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('issue_content', template: 'routines/index')
      end
    end
  end

  def show
    @routine = Routine.find(params[:id])
  end
  
  private
  
  def initialize_issue_type(user)
    issue_type = params[:issue_type].presence || user&.sleep_issue&.issue_type
    user.update_issue_type(issue_type) if issue_type.present?
    @current_issue_type = issue_type
    @selected_issue_point = user.selected_issue_point
  end

  def initialize_routines(user)
    @routines = user.routines_based_on_issue
    set_routines
  end

  def set_routines
    @routines_before0 = @routines.where(recommend_time: 'before0')
    @routines_before1 = @routines.where(recommend_time: %w[before1 before1_5])
    @routines_before3 = @routines.where(recommend_time: %w[before3 before10])
  end
end
