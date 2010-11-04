require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecureString" do

  describe "Base64 Methods" do
    
    before(:all) do
      @messages = MESSAGES
    end
    
    it 'should convert self to Base64; not URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        # First make sure that line feeds are being put in somewhere.
        ss.to_base64(false).should include("\n")
        # Now, compare the data itself (no line-feeds).
        ss.to_base64(false).delete("\n").should == message[:base64].delete("\n")
      end
    end
    
    it 'should convert self to Base64; URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        # First make sure that there are no line feeds.
        ss.to_base64(true).should_not include("\n")
        # Now compare the result with the line-feed less expected value.
        ss.to_base64(true).should == message[:base64].delete("\n")
      end
    end
    
    it 'should default to URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.to_base64.should == ss.to_base64(true)
      end
    end
    
    it 'should convert self from Base64' do
      @messages.each do |message|
        ss = SecureString.new(message[:base64])
        ss.from_base64.should == message[:string]
      end
    end
  end
  
end