require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecureString" do

  describe "Base64 Methods" do
    
    before(:all) do
      @messages = MESSAGES
    end
    
    it 'should convert self to Base64; not URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        # Compare the data with the base ruby methods.
        ss.to_base64.should == Base64.encode64(message[:string])
      end
    end
    
    it 'should convert self to Base64; URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        # Compare the result with the base ruby methods.
        ss.to_base64(:url_safe => true).should == Base64.urlsafe_encode64(message[:string])
      end
    end
    
    it 'should convert base64 with no line breaks' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.to_base64(:no_break => true).should == message[:base64].delete("\n")
      end
    end
    
    it 'should default to NOT URL safe' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.to_base64.should == ss.to_base64(:url_safe => false)
      end
    end
    
    it 'should convert self from Base64' do
      @messages.each do |message|
        ss = SecureString.new(message[:base64])
        ss.from_base64.should == message[:string]
      end
    end
    
    it 'should gracefully error if you provide something other than a hash to options.' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        (lambda {ss.to_base64(true)}).should raise_error(ArgumentError)
        (lambda {ss.from_base64(true)}).should raise_error(ArgumentError)
      end
    end
    
    it 'should return SecureString instances' do
      @messages.each do |message|
        ss = SecureString.new(message[:string]).to_base64
        ss.should be_kind_of(SecureString)
        ss = SecureString.new(message[:base64]).from_base64
        ss.should be_kind_of(SecureString)
      end
    end
  end
  
end