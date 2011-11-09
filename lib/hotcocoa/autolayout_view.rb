##
# HotCocoa wrapper around Cocoa AutoLayout.
#
# Reference: http://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html#//apple_ref/doc/uid/TP40010853-CH1-SW1
module HotCocoa

  class LayoutConstraints

    attr_reader :constraints

    def initialize dude, options
      @constraints =
        NSLayoutConstraint.constraintsWithVisualFormat  options.delete(:format),
                                              options: (options.delete(:options) || 0),
                                              metrics:  options.delete(:metrics),
                                                views:  options.delete(:views).merge({ 'self' => dude })
      # need to create a constraint that references other views in dictionary format
      # dictionary of views is trivialised by Ruby's literal syntax for hashes
      # so, we just put { button1: var, button2: var2 } as the argument
    end

  end


  class AutoLayoutView < NSView
    ##
    # @note `:leading` and `:trailing` are equivalent to `:left` and
    #       `:right` for left-to-right languages, but are `:right` and
    #       `:left` for right-to-left languages.
    #
    # The available attributes that can be used in a constraint.
    #
    # @return [Array<Symbol>]
    ATTRIBUTES = [:left, :right, :top, :bottom, :leading, :trailing, :width, :height, :center_x, :center_y, :baseline]

  end

end
