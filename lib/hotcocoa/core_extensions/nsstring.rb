##
# HotCocoa extensions for the NSString class.
class NSString

  ##
  # Borrowed from Active Support.
  def underscore
    new_string = gsub /::/, '/'
    new_string.gsub! /([A-Z]+)([A-Z][a-z])/, '\1_\2'
    new_string.gsub! /([a-z\d])([A-Z])/, '\1_\2'
    new_string.tr! '-', '_'
    new_string.downcase!
    new_string
  end

  ##
  # Borrowed from Active Support.
  def camel_case
    to_s.gsub /(?:^|_)(.)/ do $1.upcase end
  end

end
