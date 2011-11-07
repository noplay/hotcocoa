class TestNSMutableAttributedStringExt < MiniTest::Unit::TestCase

  def attrs
    {
      NSFontAttributeName => NSFont.toolTipsFontOfSize(10),
      NSObliquenessAttributeName => 5.0
    }
  end

  def attr_string value = 'test'
    string = NSMutableAttributedString.alloc.initWithString value,
                                                attributes: attrs
  end

  def test_append_another_attributed_string
    string = attr_string
    other_string = attr_string ' other'
    string << other_string
    assert_equal 'test other', string.string
    assert_equal attrs, string.fontAttributesInRange(NSRange.new 0, 10)
  end

  def test_append_a_string
    string = attr_string
    string << ' string'
    assert_equal 'test string', string.string
  end

  def test_replace_range_with_string
    string = attr_string 'my string'
    string[0..-1] = 'bwa ha ha'
    assert_equal 'bwa ha ha', string.string

    string[0...1] = 'm'
    assert_equal 'mwa ha ha', string.string

    string[0..8] = 'my string'
    assert_equal 'my string', string.string

    string[0...9] = 'bwa ha ha'
    assert_equal 'bwa ha ha', string.string
  end

  def test_replace_range_with_attributed_string
    string        = attr_string 'my string'
    string[0..-1] = attr_string 'bwa ha ha'
    assert_equal 'bwa ha ha', string.string
    assert_equal attrs, string.fontAttributesInRange(NSRange.new 0, 9)
  end

end
