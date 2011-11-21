##
# HotCocoa extensions for the NSArray class
class NSArray
  ##
  # @deprecated Does anyone use this?
  #
  # Equivalent to `#[1]`, borrowed from Active Support.
  def second
    at(1)
  end

  ##
  # @deprecated Does anyone use this?
  #
  # Equivalent to `#[2]`, borrowed from Active Support.
  def third
    at(2)
  end
end
