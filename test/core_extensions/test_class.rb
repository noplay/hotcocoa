class TestClassExt < MiniTest::Unit::TestCase

  def test_mappers_returns_list_of_mappers
    assert_kind_of HotCocoa::Mappings::Mapper, NSView.hotcocoa_mappers.first
  end

  def test_mappers_empty_for_non_mapped_class
    assert_empty NSURL.hotcocoa_mappers
  end

  def test_mappers_correct_order
    mappers = HotCocoa::Mappings.mappings.values

    expected = []
    expected << mappers.find { |x| x.control_class == NSView    }
    expected << mappers.find { |x| x.control_class == NSControl }
    expected << mappers.find { |x| x.control_class == NSButton  }

    assert_equal expected, NSButton.hotcocoa_mappers
  end

end
