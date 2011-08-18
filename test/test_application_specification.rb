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

  def rescue_spec_error_for &block
    begin
      Specification.new &block
    rescue Specification::Error => e
      return e
    end
  end

  def minimal_spec
    Specification.new do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      yield s if block_given?
    end
  end

  def test_spec_requires_a_block
    error = rescue_spec_error_for # no block given
    assert_match /must pass a block/, error.message
  end

  def test_name_is_string_of_given_name
    ['Test', [1,2,3]].each do |name|
      spec = Specification.new do |s|
        s.name       = name
        s.identifier = 'com.test.test'
      end
      assert_equal name.to_s, spec.name
    end
  end

  def test_name_is_verified
    exception = rescue_spec_error_for { |_| }
    assert_match /name is required/, exception.message

    exception = rescue_spec_error_for { |s| s.name = '' }
    assert_match /cannot be an empty string/, exception.message
  end

  def test_name_warns_if_too_long
    output = capture_io do
      rescue_spec_error_for { |s| s.name = 'Really long app name' }
    end
    assert_match /should be less than 16 characters/, output.last
  end

  def test_identifier_is_verified
    exception = rescue_spec_error_for { |s| s.name = 'test' }
    assert_match /identifier is required/, exception.message

    exception = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = ''
    end
    assert_match /cannot be an empty string/, exception.message
  end

  def test_identifier_limits_character_set
    exception = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = ','
    end
    assert_match /bundle identifier may only/, exception.message
    assert_match /You had ","/, exception.message
  end

  def test_version_defaults_to_1_if_not_set
    assert_equal '1.0', minimal_spec.version
  end

  def test_version_is_forced_to_a_string
    spec = minimal_spec do |s|
      s.version    = 3.1415
    end
    assert_equal '3.1415', spec.version
  end

  def test_short_version_is_empty_by_default
    assert_nil minimal_spec.short_version
  end

  def test_short_version_is_forced_to_a_string_if_defined
    spec = minimal_spec do |s|
      s.short_version = 3.1415
    end
    assert_equal '3.1415', spec.short_version
  end

  def test_copyright_is_verified
    assert_nil minimal_spec.copyright

    spec = minimal_spec do |s|
      s.copyright = Math::PI
    end
    assert_equal Math::PI.to_s, spec.copyright
  end

  def test_type_has_a_default
    assert_equal 'APPL', minimal_spec.type

    spec = minimal_spec { |s| s.type = 'BNDL' }
    assert_equal 'BNDL', spec.type
  end

  def test_type_is_verified
    error = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      s.type       = 'TOO LONG'
    end
    assert_match /bundle type must be exactly 4 characters/, error.message

    error = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      s.type       = 'TOO'
    end
    assert_match /bundle type must be exactly 4 characters/, error.message
  end

  def test_signature_has_a_default
    assert_equal '????', minimal_spec.signature

    spec = minimal_spec { |s| s.signature = 'girb' }
    assert_equal 'girb', spec.signature
  end

  def test_signature_is_verified
    error = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      s.signature  = 'thingy'
    end
    assert_match /bundle signature must be exactly 4 characters/, error.message

    error = rescue_spec_error_for do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      s.signature  = 'two'
    end
    assert_match /bundle signature must be exactly 4 characters/, error.message
  end

  def test_agent_has_a_default
    assert_equal false, minimal_spec.agent

    spec = minimal_spec { |s| s.agent = true }
    assert_equal true, spec.agent
  end

  def test_agent_is_verified
    spec = minimal_spec { |s| s.agent = 'cake' }
    assert_equal true, spec.agent

    spec = minimal_spec { |s| s.agent = nil }
    assert_equal false, spec.agent
  end

  def test_sources_resources_and_data_models_are_initialized_to_an_empty_array_if_not_provided
    spec = minimal_spec
    assert_empty spec.sources
    assert_empty spec.resources
    assert_empty spec.data_models
  end

  def test_stdlib_attribute_true_by_default
    spec = minimal_spec
    assert_equal true, spec.stdlib

    spec = minimal_spec { |s| s.stdlib = false }
    assert_equal false, spec.stdlib

    libs = ['base64', 'matrix']
    spec = minimal_spec { |s| s.stdlib = libs }
    assert_equal libs, spec.stdlib
  end

  def test_compile_is_true_by_default
    spec = minimal_spec
    assert spec.compile?
    assert spec.compile

    spec = minimal_spec { |s| s.compile = false }
    refute spec.compile?
    refute spec.compile
  end


  def test_overwirte_attribute_is_false_by_default
    spec = minimal_spec
    refute spec.overwrite?

    spec = minimal_spec { |s| s.overwrite = true }
    assert spec.overwrite?
  end

  def test_icon_exists?
    spec = Specification.load HOTCONSOLE
    refute spec.icon_exists?

    # works because this project uses the icon from a system app
    spec = Specification.load CALCULATOR
    assert spec.icon_exists?
  end

  # doubles as an integration test
  def test_load_evaluates_files_properly
    spec = Application::Specification.load HOTCONSOLE
    assert_equal 'HotConsole',                     spec.name
    assert_equal 'com.vincentisambart.HotConsole', spec.identifier
    assert_equal '1.0',                            spec.version
    assert_equal Dir.glob('lib/**/*.rb'),          spec.sources
    assert_equal [],                               spec.resources
    assert_equal 'girb',                           spec.signature

    spec = Application::Specification.load STOPWATCH
    assert_equal 'Stopwatch',                         spec.name
    assert_equal 'nz.co.kearse.stopwatch',            spec.identifier
    assert_equal Dir.glob('{lib,hotcocoa}*/**/*.rb'), spec.sources
    assert_equal [],                                  spec.resources
    assert_equal true,                                spec.agent
    assert_equal true,                                spec.overwrite
    assert_equal false,                               spec.stdlib
  end

end
