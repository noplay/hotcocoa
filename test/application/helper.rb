require 'hotcocoa/application/builder'

class TestApplicationModule < MiniTest::Unit::TestCase
  include Application

  def hotconsole_spec
    @@hotconsole_spec ||= Specification.load 'test/fixtures/hotconsole.appspec'
  end
  def stopwatch_spec
    @@stopwatch_spec  ||= Specification.load 'test/fixtures/stopwatch.appspec'
  end

  def minimal_spec
    Specification.new do |s|
      s.name       = 'test'
      s.identifier = 'com.test.test'
      yield s if block_given?
    end
  end

end
