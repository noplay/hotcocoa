class TestNSArrayExt < MiniTest::Unit::TestCase

  def test_convenience_accessors
    array = NSArray.arrayWithArray([Math::PI, 42, 0.5])
    assert_equal 42, array.second
    assert_equal 0.5, array.third
  end

end
