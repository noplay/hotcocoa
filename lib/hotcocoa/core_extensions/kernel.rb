##
# HotCocoa extensions for the Kernel module
module Kernel

  alias_method :default_framework, :framework
  ##
  # Override MacRuby's built-in #framework method in order to support lazy
  # loading frameworks inside of HotCocoa.
  def framework name
    if default_framework name
      HotCocoa::Mappings.framework_loaded name
      true
    else
      false
    end
  end

  ##
  # A mapping, lol
  PLIST_FORMATS = {
    xml:    NSPropertyListXMLFormat_v1_0,
    binary: NSPropertyListBinaryFormat_v1_0
  }

  ##
  # @todo encoding format can be pushed upstream?
  #
  # Override MacRuby's built-in {Kernel#to_plist} method to support
  # specifying an output format. See {PLIST_FORMATS} for the available
  # formats.
  #
  # @example Encoding a plist in the binary format
  #  { key: 'value' }.to_plist(:binary)
  #
  # @return [String] returns `self` serialized as a plist and encoded
  #   using `format`
  def to_plist format = :xml
    format_const = PLIST_FORMATS[format]
    raise ArgumentError, "invalid format `#{format}'" unless format_const

    error = Pointer.new(:id)
    data  = NSPropertyListSerialization.dataFromPropertyList  self,
                                                      format: format_const,
                                            errorDescription: error
    error[0] ? raise( Exception, error[0] ) : data.to_str
  end

end
