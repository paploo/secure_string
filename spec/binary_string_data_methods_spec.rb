require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecurityString" do
  
  before(:all) do
    @messages = MESSAGES
  end
  
  describe "Binary String Data Methods" do
  
    it 'should be able to convert to a hex string' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.data_to_hex.should == message[:hex]
      end
    end
  
    it 'should be able to convert to an int value' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.data_to_i.should == message[:int]
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
        ss.inspect.should include(ss.data_to_hex)
        ss.inspect.should_not include(s.to_s)
      end
    end
    
    it 'should return appropriate values on an empty string' do
      ss = SecureString.new('')
      
      ss.data_to_hex.should == ''
      ss.data_to_i.should be_kind_of(Integer)
      ss.data_to_i.should == 0
    end
    
    it 'should be able to convert to an escaped hex string' do
      @messages.each do |message|
        ss = SecureString.new(message[:string])
        ss.data_to_escaped_hex.delete('^0-9A-Fa-f').should == message[:hex]
        ss.data_to_escaped_hex.should == message[:string].each_byte.map {|b| '\x' + ('%02x' % b)}.join
      end
    end
    
  end
  
end