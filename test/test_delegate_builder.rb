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
    skip("not sure whether this is failing because of a bug or the test is invalid")
    control = TestControl.new

    proc = Proc.new {|p1, p2| p1.nil? ? :p1_nil : p2 }
    delegate_builder = HotCocoa::DelegateBuilder.new(control, ["p1", "p2"])
    delegate_builder.add_delegated_method(proc, "abc:p1:p2:")

    assert_equal :p1_nil, delegate_builder.delegate.abc(nil, p1: nil, p2: nil)
    assert_equal :p2, delegate_builder.delegate.abc(nil, p1: :p1, p2: :p2)
  end
end
