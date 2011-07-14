class TestNumericExt < MiniTest::Unit::TestCase

  def test_negative?
    assert -1.negative?
    assert -1.1.negative?
    refute 1.negative?
    refute 1.1.negative?
  end

end
