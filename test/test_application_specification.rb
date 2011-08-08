require 'hotcocoa/application/specification'

class TestApplicationSpecification < MiniTest::Unit::TestCase
  include Application

  TEST_DIR = File.join(ENV['TMPDIR'], 'test_app_specification')

  # Some HotCocoa appspec files, converted from build.yml files borrowed from projects on Github
  HOTCONSOLE = 'test/fixtures/hotconsole.appspec'
  CALCULATOR = 'test/fixtures/calculator.appspec'
  STOPWATCH  = 'test/fixtures/stopwatch.appspec'
  EMPTY_APP  = 'test/fixtures/empty.appspec'

  def setup;    FileUtils.mkdir TEST_DIR; end
  def teardown; FileUtils.rm_rf TEST_DIR; end

  def test_reads_attributes
    spec = Specification.load HOTCONSOLE
    assert_equal 'HotConsole',                spec.name
    assert_equal '1.0',                       spec.version
    assert_equal 'resources/HotConsole.icns', spec.icon

    spec = Specification.load CALCULATOR
    assert_equal 'Calculator', spec.name
    assert_equal '2.0', spec.version
  end

  def test_name_is_verified
    ['Test', [1,2,3]].each do |name|
      spec = Specification.new { |s| s.name = name }
      assert_equal name.to_s, spec.name
    end

    exception = nil

    begin
      Specification.new { |_| }
    rescue Specification::Error => e
      exception = e
    end
    assert_match /name is required/, exception.message

    begin
      Specification.new { |s| s.name = '' }
    rescue Specification::Error => e
      exception = e
    end
    assert_match /cannot be an empty string/, exception.message
  end

  def test_version_defaults_to_1_if_not_set
    spec = Specification.load STOPWATCH
    refute_nil spec.version
    assert_equal '1.0', spec.version
  end

  def test_sources_resources_and_data_models_are_initialized_to_an_empty_array_if_not_provided
    spec = Specification.load EMPTY_APP
    assert_empty spec.sources
    assert_empty spec.resources
    assert_empty spec.data_models
  end

  def test_overwirte_attribute
    spec = Specification.load EMPTY_APP
    refute spec.overwrite?

    spec = Specification.load STOPWATCH
    assert spec.overwrite?
  end

  def test_stdlib_attribute
    spec = Specification.load HOTCONSOLE
    assert_equal true, spec.stdlib

    spec = Specification.load STOPWATCH
    assert_equal false, spec.stdlib
  end

  def test_type_attribute
    spec = Specification.load HOTCONSOLE
    assert_equal 'APPL', spec.type

    spec = Specification.load EMPTY_APP
    assert_equal 'BNDL', spec.type
  end

  def test_signature_attribute
    spec = Specification.load EMPTY_APP
    assert_equal '????', spec.signature

    spec = Specification.load HOTCONSOLE
    assert_equal 'girb', spec.signature
  end

  def test_icon_exists?
    spec = Specification.load HOTCONSOLE
    refute spec.icon_exists?

    # works because this project uses the icon from a system app
    spec = Specification.load CALCULATOR
    assert spec.icon_exists?
  end

end
