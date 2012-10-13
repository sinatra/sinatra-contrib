require 'test/unit'
require '../lib/sinatra/content_for.rb'

class TestContentFor < Test::Unit::TestCase
  include Sinatra::ContentFor

  def test_content_for_block
    value = 'value'
    content_for :key do
      value
    end
    assert_equal value, yield_content(:key)
  end

  def test_content_for_immediate
    immediate = 'immediate'
    content_for :key, immediate
    assert_equal immediate, yield_content(:key)
  end
end
