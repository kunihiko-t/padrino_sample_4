require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class PushNotificationTest < Test::Unit::TestCase
  context "PushNotification Model" do
    should 'construct new instance' do
      @push_notification = PushNotification.new
      assert_not_nil @push_notification
    end
  end
end
