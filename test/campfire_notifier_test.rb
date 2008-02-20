require 'rubygems'
require File.dirname(__FILE__) + '/../campfire_notifier'
require 'rubygems'
require 'mocha'
require 'test/spec'

describe "CampfireNotifier" do
  it "speaks when the build is fixed" do
    notifier = CampfireNotifier.new
    build = stub(:label => "label")
    notifier.expects(:speak).with("Build fixed in label")
    notifier.expects(:clear_flag)
    notifier.build_fixed(build)
  end
  it "speaks when the build is successful" do
    notifier = CampfireNotifier.new
    build = stub(:label => "label", :failed? => false)
    notifier.expects(:speak).with("Build label successful")
    notifier.expects(:clear_flag)
    notifier.build_finished(build)
  end
  it "speaks when the build fails" do
    notifier = CampfireNotifier.new
    build = stub(:label => "label", :failed? => true)
    notifier.expects(:speak).with("Build label broken")
    notifier.expects(:clear_flag)
    notifier.build_finished(build)
  end
  it "recognize apr_error as svn failures" do
    notifier = CampfireNotifier.new
    notifier.is_subversion_down?(stub(:message => "apr_error=something")).should == true
  end
  it "recognize PROPFIND request failure as svn failures" do
    notifier = CampfireNotifier.new
    notifier.is_subversion_down?(stub(:message => "svn: PROPFIND request failed|apr_error")).should == true
  end
  it "speaks when the build loop fails because of a subversion error" do
    notifier = CampfireNotifier.new
    notifier.stubs(:flagged?).returns(false)
    notifier.expects(:speak).with("Build loop failed: Error connecting to Subversion: svn: PROPFIND request failed")
    notifier.expects(:is_subversion_down?).returns(true)
    notifier.expects(:set_flag)
    notifier.build_loop_failed(stub(:message => "svn: PROPFIND request failed"))
  end
  it "doesn't spam campfire when failing because it's not an svn error" do
    notifier = CampfireNotifier.new
    notifier.stubs(:flagged?).returns(false)
    notifier.expects(:speak).times(2)
    notifier.expects(:is_subversion_down?).returns(false)
    notifier.build_loop_failed(stub_everything(:backtrace => [:x, :y, :z, :a, :b]))
  end
  it "room is nil if room_name is nil" do
    notifer = CampfireNotifier.new
    notifer.stubs(:settings).returns(stub_everything)
    notifer.room_name = nil
    notifer.room.should == nil
  end
  it "delegates settings to the class variable settings" do
    CampfireNotifier.stubs(:settings).returns(settings = stub)
    CampfireNotifier.new.settings.should == settings
  end
end