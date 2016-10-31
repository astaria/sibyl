require 'test_helper'

module Sibyl
  class EditorControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get editor_index_url
      assert_response :success
    end

    test "should get edit" do
      get editor_edit_url
      assert_response :success
    end

  end
end
