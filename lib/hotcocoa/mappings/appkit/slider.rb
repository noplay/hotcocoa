HotCocoa::Mappings.map slider: :NSSlider do

  defaults frame: CGRectZero, layout: {}

  def init_with_options button, options
    button.initWithFrame options.delete(:frame)
  end

  custom_methods do
    method_alias :min=, 'setMinValue:'
    method_alias :max=, 'setMaxValue:'
    method_alias :tic_marks=, 'setNumberOfTickMarks:'
  end

end
