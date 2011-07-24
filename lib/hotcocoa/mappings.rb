module HotCocoa::Mappings
  # they need to be initialized
  @mappings   = {}
  @frameworks = Hash.new { |h,k| h[k] = [] }
end

class << HotCocoa::Mappings

  ##
  # Returns the Hash of mappings.
  attr_reader :mappings

  ##
  # Returns the Hash of mapped frameworks.
  attr_reader :frameworks

  ##
  # @todo Move to a strategy where we load mappings only once the
  #       framework is loaded.
  #
  # Load _EVERYTHING_ in `lib/hotcocoa/mappings`, recursively
  def reload
    pattern = File.join(File.dirname(__FILE__), 'mappings', '**', '*.rb')
    Dir.glob(pattern).each { |mapping| require mapping.chomp!('.rb') }
  end

  # @group Creating a new mapping

  ##
  # @todo Needs docs for all possible invocations and examples!
  #
  # Create a new mapping. There are several ways to call this method
  # for different cases, only some are currently documented.
  #
  # @overload map( window: NSWindow )
  # @overload map( window: :NSWindow,  framework: 'AppKit' )
  # @overload map( window: 'NSWindow', framework: 'AppKit' )
  #   In order to define a mapping without loading the dependant framework
  def map options, &block
    mapped_name, mapped_value = options.first

    if mapped_value.kind_of? Class # we support mapping subclasses of Class?
      add_mapping mapped_name, mapped_value, &block

    else
      framework = options[:framework].to_s
      if framework.empty? || loaded_frameworks.include?(framework)
        add_constant_mapping mapped_name, mapped_value, &block
      else
        on_framework framework do
          add_constant_mapping mapped_name, mapped_value, &block
        end
      end
    end
  end

  ##
  # Registers `mapped_name` as a builder method for `mapped_class`.
  #
  # @param [Symbol] mapped_name
  # @param [Class]  mapped_class
  def add_mapping mapped_name, mapped_class, &block
    m = HotCocoa::Mappings::Mapper.map_instances_of mapped_class, mapped_name, &block
    mappings[mapped_name] = m
  end

  ##
  # When a mapping maps to a class that was given as a String/Symbol
  # (because the class is not loaded yet), this method looks up the
  # constant and then delegates to {#add_mapping}.
  def add_constant_mapping mapped_name, constant, &block
    add_mapping mapped_name, Object.full_const_get(constant), &block
  end

  # @group Delayed mapping for frameworks not loaded yet

  ##
  # Registers a callback for when the specified framework has been
  # loaded.
  #
  # @param [String] name framework name
  def on_framework name, &block
    frameworks[name] << block
  end

  ##
  # Registers a given framework as being loaded and activates mappings
  # for that framework.
  #
  # @param [String] name
  def framework_loaded name
    loaded_frameworks << name
    frameworks[name].each &:call
    frameworks.delete name
  end

  ##
  # @todo Caching exposes a potential issue with loading frameworks on
  #       threads. Though I'm not sure if that is an issue worth
  #       worrying about, or if we can do much avoid the problem.
  #
  # Return the list of loaded frameworks, which might contain some
  # duplicates.
  #
  # @return [Array<String>]
  def loaded_frameworks
    @loaded_frameworks ||= NSBundle.allFrameworks.map { |bundle|
      bundle.bundlePath.split('/').last
    }.select { |framework|
      framework.split('.')[1] == 'framework'
    }.map { |framework|
      framework.split('.')[0]
    }
  end

end
