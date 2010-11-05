require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecurityString" do
  
  before(:all) do
    @messages = MESSAGES
  end
  
  describe "Binary String Data Methods" do
  
    it 'should be able to convert to a hex string' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.to_hex.should == message[:hex]
      end
    end
  
    it 'should be able to convert to an int value' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.to_i.should == message[:int]
      end
    end
  
    it 'should output like a string for to_s' do
      @messages.each do |message|
        s = String.new(message[:string])
        ss = SecureString.new(message[:string])
        ss.to_s.should == s.to_s
      end
    end
  
    it 'should output the hex value with inspect' do
      @messages.each do |message|
        s = String.new(message[:string])
        ss = SecureString.new(message[:string])
        ss.inspect.should include(ss.to_hex)
        ss.inspect.should_not include(s.to_s)
      end
    end
    
  end
  
end