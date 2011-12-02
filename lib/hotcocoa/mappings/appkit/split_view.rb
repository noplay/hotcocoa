HotCocoa::Mappings.map split_view: NSSplitView do

  defaults layout: {}

  def init_with_options split_view, options
    split_view.initWithFrame options.delete :frame
  end

  custom_methods do
    def horizontal= value
      setVertical !value
    end

    def set_position position, of_divider_at_index: index
      setPosition position, ofDividerAtIndex: index
    end
  end

  delegating 'splitView:resizeSubviewsWithOldSize:',                            to: :resize_subviews_with_old_size,  parameters: [:resizeSubviewsWithOldSize]
  delegating 'splitViewWillResizeSubviews:',                                    to: :will_resize_subviews
  delegating 'splitViewDidResizeSubviews:',                                     to: :did_resize_subviews
  delegating 'splitView:canCollapseSubview:',                                   to: :can_collapse_subview?,          parameters: [:canCollapseSubview]
  delegating 'splitView:shouldCollapseSubview:forDoubleClickOnDividerAtIndex:', to: :should_collapse_subview?,       parameters: [:shouldCollapseSubview, :forDoubleClickOnDividerAtIndex]
  delegating 'splitView:shouldAdjustSizeOfSubview:',                            to: :should_adjust_size_of_subview?, parameters: [:shouldAdjustSizeOfSubview]

  # this is commented out because using the following mapping causes a MacRuby bug:
  #  *unknown: [BUG] Object: SubtypeUntil: end of type encountered prematurely
  # delegating 'splitView:effectiveRect:forDrawnRect:ofDividerAtIndex:', to: :effective_rect_for_drawn_rect_of_divider_at_index, parameters: [:effectiveRect, :forDrawnRect, :ofDividerAtIndex]
  delegating 'splitView:shouldHideDividerAtIndex:',                    to: :should_hide_divider_at_index?,                     parameters: [:shouldHideDividerAtIndex]
  delegating 'splitView:additionalEffectiveRectOfDividerAtIndex:',     to: :additional_effective_rect_of_divider_at_index,     parameters: [:additionalEffectiveRectOfDividerAtIndex]
  
  delegating 'splitView:constrainMaxCoordinate:ofSubviewAt:', to: :constrain_max_coordinate_of_subview_with_index, parameters: [:constrainMaxCoordinate, :ofSubviewAt]
  delegating 'splitView:constrainMinCoordinate:ofSubviewAt:', to: :constrain_min_coordinate_of_subview_with_index, parameters: [:constrainMinCoordinate, :ofSubviewAt]
  delegating 'splitView:constrainSplitPosition:ofSubviewAt:', to: :constrain_split_position_of_subview_with_index, parameters: [:constrainSplitPosition, :ofSubviewAt]
end
