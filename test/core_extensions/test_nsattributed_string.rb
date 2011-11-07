class TestNSAttributedStringExt < MiniTest::Unit::TestCase

  def attrs
    {
      NSFontAttributeName => NSFont.toolTipsFontOfSize(10),
      NSObliquenessAttributeName => 5.0
    }
  end

  def attr_string value = 'test'
    string = NSAttributedString.alloc.initWithString value,
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

end
