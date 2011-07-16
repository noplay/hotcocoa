class TestColorMappings < MiniTest::Unit::TestCase

  def test_given_a_name
    assert_equal NSColor.redColor, HotCocoa.color(name: 'red')
    assert_equal NSColor.greenColor, HotCocoa.color(name: 'green')
    assert_equal NSColor.lightGrayColor, HotCocoa.color(name: 'lightGray')
  end

end
