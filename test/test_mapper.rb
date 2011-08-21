# Originally imported from MacRuby sources

class TestMapperDetails < MiniTest::Unit::TestCase
  include HotCocoa::Mappings

  def test_module_has_bindings_and_delegate_caches
    assert_instance_of Hash, Mapper.bindings_modules
    assert_instance_of Hash, Mapper.delegate_modules
  end

  def test_exposes_control_class
    assert_respond_to sample_mapper, :control_class
    refute_respond_to sample_mapper, :control_class=
  end

  def test_exposes_builder_method
    assert_respond_to sample_mapper, :builder_method
    refute_respond_to sample_mapper, :builder_method=
  end

  def test_exposes_control_module
    assert_respond_to sample_mapper, :control_module
    refute_respond_to sample_mapper, :control_module=
  end

  def test_exposes_map_bindings
    assert_respond_to sample_mapper, :map_bindings
    assert_respond_to sample_mapper, :map_bindings=
  end

  def test_sets_its_control_class_on_initialization
    assert_equal sample_mapper(true).control_class, SampleClass
  end

  def test_include_in_class
    m = sample_mapper true
    m.include_in_class

    assert_equal m.instance_variable_get(:@extension_method), :include

    skip 'Pending.'
  end


  private

  def sample_mapper flush = false
    @mapper = nil if flush
    @mapper ||= Mapper.new(SampleClass)
  end

end


class TestMapperFeatures < MiniTest::Unit::TestCase

  def teardown
    HotCocoa::Mappings.mappings[:sample] = nil
  end

  def test_handle_block_called_if_implemented
    HotCocoa::Mappings.map sample: SampleClass do
      def alloc_with_options opts
        SampleClass.new
      end
      def handle_block inst
        inst.instance_variable_set(:@cache, yield(inst))
      end
    end
    object = HotCocoa.sample { |_| :cake_is_the_truth }
    assert_equal :cake_is_the_truth, object.instance_variable_get(:@cache)
  end

  def test_block_is_executed_if_given
    HotCocoa::Mappings.map sample: SampleClass do
      def alloc_with_options opts
        SampleClass.new
      end
    end
    yielded = false
    object  = HotCocoa.sample { |inst| yielded = inst }
    assert_equal object, yielded
  end

  def test_custom_methods_override_existing_methods
    HotCocoa::Mappings.map sample: SampleClass do
      def alloc_with_options opts
        SampleClass.new
      end
      custom_methods do
        def some_method
          true
        end
      end
    end
    object = HotCocoa.sample
    assert_equal true, object.some_method
  end

end
