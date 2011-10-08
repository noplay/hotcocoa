# Integration tests
class TestNotificationListener < MiniTest::Unit::TestCase
  include HotCocoa

  def teardown
    NotificationListener.registered_listeners.each &:stop_listening
  end

  def test_requires_a_block
    assert_raises ArgumentError do
      NotificationListener.new
    end
  end

  def test_caches_listeners
    listener = NotificationListener.new { |_| }
    assert_includes NotificationListener.registered_listeners, listener
  end

  def test_executes_block_when_notif_is_received
    got_callback = false
    NotificationListener.new named: 'test' do |_|
      got_callback = true
    end
    NSNotificationCenter.defaultCenter.postNotificationName 'test',
                                                    object: self
    assert got_callback
  end

  def test_can_stop_listening
    got_callback = false
    listener = NotificationListener.new named: 'test2' do |_|
      got_callback = true
    end
    listener.stop_listening
    NSNotificationCenter.defaultCenter.postNotificationName 'test2',
                                                    object: self

    refute_includes NotificationListener.registered_listeners, listener
    refute got_callback
  end

  def test_on_notification_is_alias
    listener = ::HotCocoa.on_notification { |_| }
    assert_kind_of NotificationListener, listener
  end

end
