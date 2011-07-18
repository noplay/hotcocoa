class TestNSStringExt < MiniTest::Unit::TestCase

  def test_convert_from_camelcase_to_underscore
    assert 'SampleCamelCasedWord'.underscore, 'sample_camel_cased_word'
  end

  def test_convert_from_underscore_to_camelcase
    assert 'sample_camel_cased_word'.camel_case, 'SampleCamelCasedWord'
  end

  def test_convert_to_attributed_string
    attrs = {
      NSFontAttributeName => NSFont.toolTipsFontOfSize(10),
      NSObliquenessAttributeName => 5.0
    }
    string = 'my test string'.with_attributes attrs
    assert_equal attrs, string.fontAttributesInRange(NSRange.new 0, 10)
  end

end
