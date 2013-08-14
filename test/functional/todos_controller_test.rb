require 'test_helper'

class TodosControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should create a new todo" do
    assert_difference "Todo.count", 1 do
      post :create, content: 'a new todo', done: false
    end
  end
end
