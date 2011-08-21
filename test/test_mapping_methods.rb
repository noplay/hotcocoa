class TestMappingMethods < MiniTest::Unit::TestCase
  class MappingMethodsTestClass
  end

  def setup
    @klass = MappingMethodsTestClass.new
    @klass.extend HotCocoa::MappingMethods
  end

  def test_there_can_only_be_one_defaults
    first_defaults  = {  first_key: 'first_value' }
    second_defaults = { second_key: 'second_value' }

    @klass.defaults first_defaults
    assert_equal first_defaults, @klass.defaults

    @klass.defaults second_defaults
    assert_equal second_defaults, @klass.defaults
  end

  def test_there_can_only_be_one_custom_methods
    first_custom_methods  = Proc.new do
      def first_method
      end
    end
    second_custom_methods = Proc.new do
      def second_method
      end
    end

    @klass.custom_methods &first_custom_methods
    assert_includes @klass.custom_methods.instance_methods, :first_method

    @klass.custom_methods &second_custom_methods
    assert_includes @klass.custom_methods.instance_methods, :second_method
  end

  def test_caches_are_initialized
    assert_kind_of Hash, @klass.constants_map
    assert_kind_of Hash, @klass.delegate_map
  end

  def test_constants_are_cached
    first_mapping  = { nice_const: 1, other: 'two'   }
    second_mapping = {          a: 2,     b: 'three' }

    @klass.constant :x, first_mapping
    assert_equal first_mapping, @klass.constants_map[:x]

    @klass.constant :y, second_mapping
    assert_equal second_mapping, @klass.constants_map[:y]
    assert_equal  first_mapping, @klass.constants_map[:x]
  end

  def test_delegate_mappings_are_cached
    first_delegate  = { to: :other_thingy }
    second_delegate = { to: :a_method, parameters: [1, 2, 3] }

    @klass.delegating :thingy, first_delegate
    assert_equal first_delegate, @klass.delegate_map[:thingy]

    @klass.delegating :thingy2, second_delegate
    assert_equal second_delegate, @klass.delegate_map[:thingy2]
    assert_equal  first_delegate, @klass.delegate_map[:thingy]
  end

end
