require 'hotcocoa/delegate_builder'

class TestControl
  attr_accessor :delegate
end

class TestDelegateBuilder < MiniTest::Unit::TestCase
  def test_that_delegate_is_set_on_control
    control = TestControl.new

    proc = Proc.new { true }
    delegate_builder = HotCocoa::DelegateBuilder.new(control, [])
    delegate_builder.add_delegated_method(proc, "abc")

    assert_equal delegate_builder.delegate, control.delegate
  end

  def test_that_delegate_implements_delegate_method_with_string_parameters
    control = TestControl.new

    proc = Proc.new {|param1, param2| param1.even? ? param1 : param2 }
    delegate_builder = HotCocoa::DelegateBuilder.new(control, [])
    delegate_builder.add_delegated_method(proc, "abc:param1:param2:", "param1", "param2")

    assert_equal 2, delegate_builder.delegate.abc(nil, param1: 2, param2: 0)
    assert_equal 0, delegate_builder.delegate.abc(nil, param1: 1, param2: 0)
  end
end

class TestDelegateMethodBuilder < MiniTest::Unit::TestCase
  def test_parameterize_selector_name
    delegate_builder = HotCocoa::DelegateMethodBuilder.new(nil)
    assert_equal "myDelegateMethod", delegate_builder.parameterize_selector_name("myDelegateMethod")
    assert_equal "myDelegateMethod p1,withArgument:p2", delegate_builder.parameterize_selector_name("myDelegateMethod:withArgument:")
  end

  def test_parameter_values_for_mapping
    delegate_builder = HotCocoa::DelegateMethodBuilder.new(nil)
    assert delegate_builder.parameter_values_for_mapping("myDelegateMethod", []).nil?
    assert_equal "p2, p3", delegate_builder.parameter_values_for_mapping("myDelegateMethod:p1:p2:", ["p1", "p2"])
    assert_equal "p1.userInfo['NSExposedRect']", delegate_builder.parameter_values_for_mapping("windowDidExpose:", ["windowDidExpose.userInfo['NSExposedRect']"])
  end
end
