require 'rubygems'
gem     'minitest'
require 'minitest/autorun'

if ENV['BENCH']
  require 'minitest/benchmark'
else
  require 'minitest/pride'
end

$LOAD_PATH.unshift File.join( File.dirname(__FILE__), '..', 'lib' )
require 'hotcocoa'

class MiniTest::Unit::TestCase
  def run_run_loop time = 1.5
    NSRunLoop.currentRunLoop.runUntilDate( Time.now + time )
  end

  def self.bench_range
    bench_exp 10, 10_000
  end
end

class SampleClass
  def some_method
    false
  end
end

SOURCE_ROOT = `git rev-parse --show-toplevel`.chomp
