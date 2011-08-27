# Originally imported from the MacRuby sources


class TestMappingsCache < MiniTest::Unit::TestCase
  include HotCocoa

  def test_keeps_a_cache_of_mappers_for_mappings
    assert_instance_of Hash, Mappings.mappings
    assert_instance_of Symbol, Mappings.mappings.keys.sample
    assert_instance_of Mappings::Mapper, Mappings.mappings.values.sample
  end

end


class TestMappingsMappings < MiniTest::Unit::TestCase
  include HotCocoa

  def teardown
    Mappings.mappings.delete :klass
  end

  def test_caches_a_mapper_with_given_arguments_to_map
    Mappings.map(klass: SampleClass) { }
    assert_equal SampleClass, Mappings.mappings[:klass].control_class
  end

  def test_registers_the_first_key_in_the_options_given_to_map_as_the_builder_method
    Mappings.map(klass: SampleClass) { }
    assert_equal Mappings.mappings[:klass].builder_method, :klass

    Mappings.map(klass: SampleClass, other_key: 'value') { }
    assert_equal Mappings.mappings[:klass].builder_method, :klass
  end

  def test_uses_the_block_given_to_map_as_the_control_module_body
    Mappings.map(klass: SampleClass) do
      def a_control_module_instance_method; end
    end

    assert_includes Mappings.mappings[:klass].control_module.
      instance_methods, :a_control_module_instance_method
  end

end


class TestMappingsMap < MiniTest::Unit::TestCase
  include HotCocoa

  def test_reload_loads_all_mappings
    file = File.join(SOURCE_ROOT, 'lib/hotcocoa/mappings/appkit/test_mapping.rb')
    File.open(file,'w') { |f| f.puts 'class MyReloadingTestClass; end' }

    HotCocoa::Mappings.reload
    assert defined?(:MyReloadingTestClass), 'mappings not loaded'
  ensure
    FileUtils.rm file
  end

  def test_loads_framework_on_demand
    dir  = File.join(SOURCE_ROOT, 'lib/hotcocoa/mappings/opencl')
    FileUtils.mkdir dir # this will fail if it already exists, which is a good safety

    file = File.join(dir, 'crazy_mapping.rb')
    File.open(file,'w') { |f| f.puts 'class MyLazyLoadingTestClass; end' }
    framework 'OpenCL'

    FileUtils.rm_rf dir

    assert defined?(:MyLazyLoadingTestClass), 'mappings not loaded'
  end

end
