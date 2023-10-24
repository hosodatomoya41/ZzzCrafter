# frozen_string_literal: true

require 'test_helper'

class RoutinesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get routines_index_url
    assert_response :success
  end
end
