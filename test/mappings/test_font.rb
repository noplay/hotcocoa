class TestFontMappings < MiniTest::Unit::TestCase

  def test_options
    assert_equal NSFont.labelFontOfSize(10), HotCocoa.font(label: 10)
    assert_equal NSFont.systemFontOfSize(15), HotCocoa.font(system: 15)
    assert_equal NSFont.controlContentFontOfSize(12), HotCocoa.font(control_content: 12)
    assert_equal NSFont.toolTipsFontOfSize(20), HotCocoa.font(tool_tip: 20)
    assert_equal NSFont.paletteFontOfSize(32), HotCocoa.font(palette: 32)
  end

  def test_size
    assert_equal 10.0, HotCocoa.font(label: 10).size
  end

end
