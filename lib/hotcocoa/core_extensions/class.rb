##
# HotCocoa extensions for the Class class.
class Class

  ##
  # @todo Complexity is almost O(|ancestors|*|mappings|), and I don't
  #       think we can fix that without changing the data structure
  #       for caching mappers.
  #
  # Returns the list of relevant HotCocoa mappers for the given class.
  # The classes are ordered in descending order (mapper for the
  # root class to the mapper for the parent class).
  #
  # @return [Array<HotCocoa::Mappings::Mapper>]
  def hotcocoa_mappers
    mappers = HotCocoa::Mappings.mappings.values
    ret     = ancestors.reverse!
    ret.map! { |ancestor|
      mappers.find { |mapper| mapper.control_class == ancestor }
    }
    ret.compact!
    ret
  end

end
