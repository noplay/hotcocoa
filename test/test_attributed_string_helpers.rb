class TestAttributedStringHelpers < MiniTest::Unit::TestCase

  def attrs
    {
      NSFontAttributeName => NSFont.toolTipsFontOfSize(10),
      NSObliquenessAttributeName => 5.0,
      NSToolTipAttributeName => 'Some tool tip text',
      NSStrikethroughColorAttributeName => NSColor.redColor
    }
  end

  def attr_string value = 'test'
    string = NSMutableAttributedString.alloc.initWithString value,
                                                attributes: attrs
  end

  def string_proxy value = 'test'
    string = attr_string value
    HotCocoa::NSRangedProxyAttributedString.new string, 0..-1
  end

  def test_proxy_attributed_string
    string = attr_string
    range  = 0..-1
    proxy  = HotCocoa::NSRangedProxyAttributedString.new string, range
    assert_same string, proxy.string
    assert_same range, proxy.range
  end

  def test_proxy_attribute_hash_reads_attributes_correctly
    attributes = string_proxy.attributes
    assert_equal attrs[NSFontAttributeName], attributes[:font]
    assert_equal attrs[NSObliquenessAttributeName], attributes[:obliqueness]
    assert_equal attrs[NSToolTipAttributeName], attributes[:tool_tip]
    assert_equal attrs[NSStrikethroughColorAttributeName], attributes[:strikethrough_color]
  end

  def test_proxy_attribute_hash_writes_attributes_correctly
    proxy = string_proxy
    attributes = proxy.attributes
    attributes[:tool_tip] = 'lol'
    value = proxy.string.attribute NSToolTipAttributeName, atIndex: 0, effectiveRange: nil
    assert_equal 'lol', value
  end

  def test_proxy_attribute_hash_appends_correctly
    proxy      = string_proxy
    attributes = proxy.attributes
    attributes << { tool_tip: 'lol', colour: NSColor.greenColor }
    tip    = proxy.string.attribute NSToolTipAttributeName, atIndex: 0, effectiveRange: nil
    colour = proxy.string.attribute NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil
    assert_equal NSColor.greenColor, colour
    assert_equal 'lol', tip
  end

  def test_proxy_attribute_hash_inspect
    assert_equal attrs, string_proxy.attributes.to_hash
    # names are not translated
    pattern = /#{attrs.keys.first.inspect}=>#{attrs.values.first.inspect}/
    assert_match pattern, string_proxy.attributes.inspect
  end

end
