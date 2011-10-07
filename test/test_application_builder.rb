require 'fileutils'
require 'yaml'

require 'hotcocoa/application_builder'

class TestConfiguration < MiniTest::Unit::TestCase

  Configuration = HotCocoa::ApplicationBuilder::Configuration
  TEST_DIR      = File.join(ENV['TMPDIR'], 'test_app_builder')

  # Some HotCocoa build.yml files, borrowed from projects on Github
  def hotconsole_config
    @@hotconsole_config ||= Configuration.new 'test/fixtures/hotconsole.yml'
  end
  def calculator_config
    @@calculator_config ||= Configuration.new 'test/fixtures/calculator.yml'
  end
  def stopwatch_config
    @@stopwatch_config ||= Configuration.new 'test/fixtures/stopwatch.yml'
  end
  def empty_config
    @@empty_config ||= Configuration.new 'test/fixtures/empty.yml'
  end

  def setup;    FileUtils.mkdir TEST_DIR; end
  def teardown; FileUtils.rm_rf TEST_DIR; end

  def test_reads_attributes
    conf = hotconsole_config
    assert_equal 'HotConsole',                conf.name
    assert_equal '1.0',                       conf.version
    assert_equal 'resources/HotConsole.icns', conf.icon
    assert_equal ['resources/**/*.*'],        conf.resources
    assert_equal ['lib/**/*.rb'],             conf.sources

    conf = calculator_config
    assert_equal 'Calculator', conf.name
    assert_equal '2.0', conf.version
  end

  def test_version_defaults_to_1_if_not_set
    conf = stopwatch_config
    refute_nil conf.version
    assert_equal '1.0', conf.version
  end

  def test_sources_resources_and_data_models_are_initialized_to_an_empty_array_if_not_provided
    conf = empty_config
    assert_empty conf.sources
    assert_empty conf.resources
    assert_empty conf.data_models
  end

  def test_overwirte_attribute
    refute empty_config.overwrite?
    assert stopwatch_config.overwrite?
  end

  def test_agent_attribute
    assert_equal '0', empty_config.agent
    assert_equal '1', stopwatch_config.agent
  end

  def test_stdlib_attribute
    assert_equal true, hotconsole_config.stdlib
    assert_equal false, stopwatch_config.stdlib
  end

  def test_type_attribute
    assert_equal 'APPL', hotconsole_config.type
    assert_equal 'BNDL', empty_config.type
  end

  def test_signature_attribute
    assert_equal '????', empty_config.signature
    assert_equal 'girb', hotconsole_config.signature
  end

  def test_icon_exists?
    refute hotconsole_config.icon_exists?
    # works on all Macs because this project uses the icon from a system app
    assert calculator_config.icon_exists?
  end

end
