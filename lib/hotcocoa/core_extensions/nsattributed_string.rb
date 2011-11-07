##
# HotCocoa extensions to the NSAttributedString class.
class NSAttributedString

  ##
  # Make a new attributed string with the string of the receiver and
  # the attributes passed as arguments.
  #
  # @param [Hash]
  # @return [NSMutableAttributedString]
  def with_attributes attributes = {}
    string.with_attributes attributes
  end

  ##
  # Just like `String#+`
  def + s
    attributed_string = mutableCopy
    attributed_string << s
    attributed_string
  end

  ##
  # Hash of attributes used in the attributed string.
  #
  # @return [HotCocoa::NSRangedProxyAttributeHash]
  def attributes
    HotCocoa::NSRangedProxyAttributedString.new(self, 0..-1).attributes
  end

  ##
  # Similar to `String#[]`, but only supports ranges at the moment.
  #
  # @param [Range]
  def [] r
    attributedSubstringFromRange r.relative_to(length)
  end

end
