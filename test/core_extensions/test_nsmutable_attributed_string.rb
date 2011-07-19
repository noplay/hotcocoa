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

  def test_with_attributes_makes_new_attributed_string
    string = NSMutableAttributedString.alloc.initWithString 'test',
                                                attributes: attrs
    refute_same string, string.with_attributes(attrs)
  end

  def test_with_attributes_uses_given_attributes
    string = NSMutableAttributedString.alloc.initWithString 'test'
    new_string = string.with_attributes attrs
    assert_equal attrs, new_string.fontAttributesInRange(NSRange.new 0, 4)
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

  def test_addition_makes_new_string
    string = attr_string
    new_string = string + string
    refute_same string, new_string
  end

  def test_addition_sends_work_to_append
    string = attr_string
    NSMutableAttributedString.send :alias_method, :__temp__, :<<
    NSMutableAttributedString.send :define_method, :<< do |_|
      @append_called = true
    end
    new_string = string + string
    assert new_string.instance_variable_get(:@append_called), 'append not called'
  ensure
    NSMutableAttributedString.send :alias_method, :<<, :__temp__
  end

  def test_attributes_returns_a_hash_of_attributes_used_on_the_string
    string = attr_string
    assert_equal attrs.sort, string.attributes.to_hash.sort
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
    string = attr_string 'my string'
    string[0..-1] = attr_string 'bwa ha ha'
    assert_equal 'bwa ha ha', string.string
    assert_equal attrs, string.fontAttributesInRange(NSRange.new 0, 9)
  end

end
