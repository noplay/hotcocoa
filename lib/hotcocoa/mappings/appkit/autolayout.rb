HotCocoa::Mappings.map autolayout: HotCocoa::AutoLayoutView do

  defaults frame: CGRectZero

  def init_with_options view, options
    view.initWithFrame options.delete :frame
  end

end
