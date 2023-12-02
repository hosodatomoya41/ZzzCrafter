# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def top
    @routine = Routine.find(5)
  end

  def privacy_policy; end

  def terms_of_service; end
end
