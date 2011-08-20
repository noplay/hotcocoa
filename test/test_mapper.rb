# Originally imported from MacRuby sources

class TestMapper < MiniTest::Unit::TestCase
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
    assert object.some_method
  end


  private

  def sample_mapper flush = false
    @mapper = nil if flush
    @mapper ||= Mapper.new(SampleClass)
  end

end
