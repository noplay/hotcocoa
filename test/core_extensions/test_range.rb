require 'hotcocoa/core_extensions/range'

class TestRangeToNSRange < MiniTest::Unit::TestCase

  def test_raises_error
    assert_raises ArgumentError do
      (1..-1).to_NSRange
    end
  end

  def array
    @@array ||= (0..10).to_a
  end

  def run_test range, *arg
    assert_equal array.slice(range), array.subarrayWithRange(range.to_NSRange(*arg)), range
  end

  def test_cases
    run_test 0..10
    run_test 1..10
    run_test 2..-1, array.size
    run_test 3..-2, array.size
    run_test 4...-1, array.size
    run_test -3...-1, array.size
    run_test -5..-1, array.size
    # run_test -1..-2, array.size # returns an empty array, is a fucked up case to begin with
  end

end
