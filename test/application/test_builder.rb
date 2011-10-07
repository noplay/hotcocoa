require 'hotcocoa/application/builder'

class TestApplicationBuilder < MiniTest::Unit::TestCase
  include Application

  TEST_DIR = File.join(ENV['TMPDIR'], 'test_app_specification')

  def hotconsole_spec
    @@hotconsole_spec ||= Specification.load 'test/fixtures/hotconsole.appspec'
  end
  def stopwatch_spec
    @@stopwatch_spec  ||= Specification.load 'test/fixtures/stopwatch.appspec'
  end

  def setup;    FileUtils.mkdir TEST_DIR; end
  def teardown; FileUtils.rm_rf TEST_DIR; end

  def test_caches_spec
    builder = Builder.new stopwatch_spec
    assert_equal stopwatch_spec, builder.spec
  end

  def test_deploy_options
    builder = Builder.new stopwatch_spec
    options = builder.send :deploy_options
    assert options.include? '--gem rest-client'
    assert options.include? '--compile'
    assert options.include? '--no-stdlib'
    refute options.include? '--bs'

    builder = Builder.new hotconsole_spec
    options = builder.send :deploy_options
    assert options.include? '--bs'
    refute options.include? '--no-stdlib'
    refute options.include? '--compile'
    refute options.include? '--gem'
  end

end
