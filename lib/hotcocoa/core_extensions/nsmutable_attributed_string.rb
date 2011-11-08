##
# HotCocoa extensions to the NSMutableAttributeString class.
class NSMutableAttributedString

  ##
  # Just like `String#<<`
  def << s
    case s
    when String
      mutableString.appendString s
    else
      appendAttributedString s
    end
  end

  ##
  # Replace an arbitrary range of an attributed string with another string.
  #
  # @param [Range] r
  # @param [NSAttributedString,String] s
  def []= r, s
    case s
    when String
      replaceCharactersInRange r.relative_to(length), withString: s
    else
      replaceCharactersInRange r.relative_to(length), withAttributedString: s
    end
  end

end
