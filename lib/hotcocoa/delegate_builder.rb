##
# Builds a delegate for a control at runtime by creating a generic object
# and adding singleton methods for each given delegate method; it then
# tells the control to delegate to that created object.
module HotCocoa
  class DelegateBuilder
    # @return The object that needs a delegate
    attr_reader :control

    # @return [Array<>] Delegate methods which are assumed to be implemented
    #    and therefore __MUST__ be given at least a stub
    attr_reader :required_methods

    # @return [Object] The delegate object
    attr_reader :delegate

    # @param control the object which needs a delegate
    # @param [Array<String>] required_methods
    def initialize control, required_methods
      @control = control
      @required_methods = required_methods
      @delegate = Object.new
    end

    ##
    # Add a delegated method for {#control} to {#delegate}
    def add_delegated_method block, selector_name, *parameters
      clear_delegate if required_methods.empty?

      DelegateMethodBuilder.new(@delegate).add_delegated_method block, selector_name, *parameters

      required_methods.delete(selector_name)
      set_delegate if required_methods.empty?
    end

    def delegate_to object, *method_names
      method_names.each do |method_name|
        control.send(method_name, &object.method(method_name)) if object.respond_to?(method_name)
      end
    end

    private
    ##
    # Reset the delegate for {#control} to `nil`.
    def clear_delegate
      control.setDelegate(nil) if control.delegate
    end

    ##
    # Set the delegate for {#control} to {#delegate}
    def set_delegate
      control.setDelegate(delegate)
    end
  end

  class DelegateMethodBuilder
    def initialize(target)
      @target = target
    end

    def add_delegated_method block, selector_name, *parameters
      bind_block_to_delegate_instance_variable(selector_name, block)
      create_delegate_method(selector_name, parameters)
    end

    def bind_block_to_delegate_instance_variable selector_name, block
      @target.instance_variable_set(block_instance_variable_for(selector_name), block)
    end

    def create_delegate_method selector_name, parameters
      needed_indices = needed_parameter_indices(selector_name, parameters)
      block_name = block_instance_variable_for(selector_name)
      @target.metaclass.send(:define_method, selector_name) do |*args|
        needed_args = args.select.with_index {|arg, i| needed_indices.include?(i)}
        instance_variable_get(block_name).call(*needed_args)
      end
    end

    ##
    # Returns an instance variable name to be used for the delegate method
    # currently being built.
    #
    # @return [String]
    def block_instance_variable_for(selector_name)
      "@block_#{selector_name.gsub(':', "_")}"
    end

    def needed_parameter_indices(selector, parameters)
      return [] if parameters.empty?
      parameters = parameters.map(&:to_s)

      selector_params = selector.split(':')
      parameters.map do |parameter|
        raise "Error in delegate mapping: '#{parameter}' is not a valid parameter of method '#{selector}'" if selector_params.index(parameter).nil?
        selector_params.index(parameter)
      end
    end
  end
end