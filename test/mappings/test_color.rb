class TestColorMappings < MiniTest::Unit::TestCase

  def rgb_test name, *components
    color = HotCocoa.color name: name
    [:redComponent, :greenComponent, :blueComponent].each do |component|
      assert_equal components.shift, color.send(component), [name, component]
    end
  end

  def test_given_a_name
    rgb_test 'red', 1, 0, 0
    rgb_test 'green', 0, 1, 0
  end

end
