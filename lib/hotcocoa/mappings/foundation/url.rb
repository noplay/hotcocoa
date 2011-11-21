HotCocoa::Mappings.map url: NSURL do

  # @todo Should default scheme be http?

  def init_with_options earl, opts
    if opts.has_key :string
      earl.initWithString opts.delete :string
    elsif opts.has_key :scheme
      earl.initWithScheme opts.delete(:scheme),
                    host: opts.delete(:host),
                    port: opts.delete(:port)
    else
      raise ArgumentError, "Can't initialize a URL with #{opts.inspect}"
    end
    earl
  end

  custom_methods do

    ALIASES = {
      to_s:    :absoluteString,
      inspect: :absoluteString
    }

    def self.included klass
      ALIASES.each_pair do |new, old|
        klass.send :alias_method, new, old
      end
    end

  end

end

##
# HotCocoa extensions for the NSURL class
class NSURL
  include HotCocoa::Behaviors
end
