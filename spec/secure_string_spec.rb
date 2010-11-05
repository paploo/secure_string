require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecureString" do
  
  before(:all) do
    @messages = MESSAGES
  end
  
  it 'should be a subclass of String' do
    (SecureString < String).should be_true
  end
  
  it 'should initialize like a string by default.' do
    @messages.each do |message|
      s = String.new(message[:string])
      ss = SecureString.new(message[:string])
      ss.should == s
    end
  end
  
  it 'should initialize from hex' do
    @messages.each do |message| 
      ss = SecureString.new(:hex, message[:hex])
      ss.should == message[:string]
    
      ss = SecureString.new(:hex, message[:hex].upcase)
      ss.should == message[:string]
    end
  end
  
  it 'should initialize from data' do
    @messages.each do |message|
      ss = SecureString.new(:data, message[:string])
      ss.should == message[:string]
    end
  end
  
  it 'should initialize from int' do
    @messages.each do |message|
      ss = SecureString.new(:int, message[:int])
      ss.should == message[:string]
    end
  end
  
  it 'should initialize from Base64' do
    @messages.each do |message|
      ss = SecureString.new(:base64, message[:base64])
      ss.should == message[:string]
    end
    
    # We also want to make sure non newline terminated, and multi-line messages
    # work right.  The sample data should contain at least one with multiple
    # linefeeds, and one with no linefeeds.
    newline_count = @messages.map {|message| message[:base64].delete("^\n").length}
    newline_count.should include(0)
    newline_count.select {|nl_count| nl_count > 1}.should_not be_empty
  end
  
end