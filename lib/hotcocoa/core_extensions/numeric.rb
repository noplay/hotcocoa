##
# HotCocoa extensions for the Numeric class
class Numeric
  ##
  # @deprecated This only exists for {Range#to_NSRange}, which has also
  #             been deprecated.
  #
  # Whether or not a number is negative
  def negative?
    self < 0
  end
end
