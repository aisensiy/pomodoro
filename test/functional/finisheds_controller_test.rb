require 'test_helper'

class FinishedsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should create a new finished" do
    t = Time.now
    finished = {
      content: 'text',
      started_at: t.to_f - 25.minutes,
      end_at: t.to_f
    }
    assert_difference "Finished.count", 1 do
      post :create, finished: finished
    end
    finished = Finished.last
    assert_equal 'text', finished.content
    assert_equal t.to_f, finished.end_at.to_f
  end
end
