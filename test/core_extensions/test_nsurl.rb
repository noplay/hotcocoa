class TestNSURLExt < MiniTest::Unit::TestCase

  def test_aliases
    url = NSURL.URLWithString 'http://macruby.org/'
    assert_equal url.inspect, url.absoluteString
    assert_equal url.to_s, url.absoluteString
  end

end
