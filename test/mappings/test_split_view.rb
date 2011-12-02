class TestSplitViewMappings < MiniTest::Unit::TestCase
  def test_defaults
    split_view = HotCocoa.split_view(frame: [0,0,10,10])
    assert_equal NSMakeRect(0,0,10,10), split_view.frame
  end

  def test_delegate_methods_for_managing_subviews
    split_view = HotCocoa.split_view(frame: [0,0,10,10]) do |v|
      v.resize_subviews_with_old_size {|old_size| old_size.map {|n| n*2}}
      v.will_resize_subviews {}
      v.did_resize_subviews {}
      v.can_collapse_subview? {|subview| not subview.nil?}
      v.should_collapse_subview? {|subview, index| not subview.nil? and not index.nil?}
      v.should_adjust_size_of_subview? {|subview| not subview.nil?}
    end

    delegate = split_view.delegate

    assert [2,4,6,8], delegate.splitView(split_view, resizeSubviewsWithOldSize: [1,2,3,4])
    assert delegate.respond_to?(:splitViewWillResizeSubviews)
    assert delegate.respond_to?(:splitViewDidResizeSubviews)    
    assert delegate.splitView(split_view, canCollapseSubview: :view)
    assert delegate.splitView(split_view, shouldCollapseSubview: :view, forDoubleClickOnDividerAtIndex: 3)
    assert delegate.splitView(split_view, shouldAdjustSizeOfSubview: :view)
  end

  def test_delegate_methods_for_configuring_and_drawing_view_dividers
    split_view = HotCocoa.split_view(frame: [0,0,10,10]) do |v|
      v.should_hide_divider_at_index? {|i| not i.nil?}
      # v.effective_rect_for_drawn_rect_of_divider_at_index {|effective_rect, drawn_rect, div_index| drawn_rect}
      v.additional_effective_rect_of_divider_at_index {|div_index| div_index}
    end

    delegate = split_view.delegate

    assert delegate.splitView(split_view, shouldHideDividerAtIndex: 1)
    # this is commented out because the test causes a MacRuby bug:
    #  *unknown: [BUG] Object: SubtypeUntil: end of type encountered prematurely
    # assert_equal [0, 0, 0, 0], delegate.splitView(split_view, effectiveRect: [1,2,3,4], forDrawnRect: [0, 0, 0, 0], ofDividerAtIndex: 0)
    assert_equal 1, delegate.splitView(split_view, additionalEffectiveRectOfDividerAtIndex: 1)
  end

  def test_delegate_methods_for_constraining_split_position
    split_view = HotCocoa.split_view(frame: [0,0,10,10]) do |v|
      v.constrain_max_coordinate_of_subview_with_index {|proposed_max, subview_index| true}
      v.constrain_min_coordinate_of_subview_with_index {|proposed_min, subview_index| true}
      v.constrain_split_position_of_subview_with_index {|proposed_position, subview_index| true}
    end

    delegate = split_view.delegate

    assert delegate.splitView(split_view, constrainMaxCoordinate: 123, ofSubviewAt: 1)
    assert delegate.splitView(split_view, constrainMinCoordinate: 123, ofSubviewAt: 1)
    assert delegate.splitView(split_view, constrainSplitPosition: 123, ofSubviewAt: 1)
  end
end
