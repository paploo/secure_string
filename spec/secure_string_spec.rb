#encoding: UTF-8

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
  
  it 'should implement to_hex' do
    SecureString.instance_methods.should include(:to_hex)
    
    @messages.each do |message|
      ss = SecureString.new(message[:string])
      ss.to_hex.should == ss.data_to_hex
    end
  end
  
  it 'should implement to_i properly' do
    SecureString.instance_methods.should include(:to_i)
    
    @messages.each do |message|
      ss = SecureString.new(message[:string])
      ss.to_i.should == ss.data_to_i
    end
  end
  
  it 'should parse hex data with spaces' do
    
    data = <<-DATA
    a766a602 b65cffe7 73bcf258 26b322b3 d01b1a97 2684ef53 3e3b4b7f 53fe3762
    24c08e47 e959b2bc 3b519880 b9286568 247d110f 70f5c5e2 b4590ca3 f55f52fe
    effd4c8f e68de835 329e603c c51e7f02 545410d1 671d108d f5a4000d cf20a439
    4949d72c d14fbb03 45cf3a29 5dcda89f 998f8755 2c9a58b1 bdc38483 5e477185
    f96e68be bb0025d2 d2b69edf 21724198 f688b41d eb9b4913 fbe696b5 457ab399
    21e1d759 1f89de84 57e8613c 6c9e3b24 2879d4d8 783b2d9c a9935ea5 26a729c0
    6edfc501 37e69330 be976012 cc5dfe1c 14c4c68b d1db3ecb 24438a59 a09b5db4
    35563e0d 8bdf572f 77b53065 cef31f32 dc9dbaa0 4146261e 9994bd5c d0758e3d"
    DATA
    
    ss = SecureString.new(:hex, data)
    
    # This was taken from a publically published SHA-0 data collision document,
    # so the best way to know that the data is good is to SHA-0 it and see if
    # we get back the value!  (http://fr.wikipedia.org/wiki/SHA-0)
    OpenSSL::Digest::SHA.hexdigest(ss).should == "c9f160777d4086fe8095fba58b7e20c228a4006b"
  end
  
  describe 'Encodings' do
    
    before(:each) do
      @unicode_string = "A resumé for the moose; Eine Zusammenfassung für die Elche; Резюме для лосей; アメリカヘラジカのための概要; Μια περίληψη για τις άλκες; 麋的一份簡歷; Un résumé pour les orignaux."
    end
    
    it 'should NOT change the encoding of a string' do
      @unicode_string.encoding.should == Encoding.find("UTF-8")
      ss = SecureString.new(@unicode_string)
      ss.encoding.should == @unicode_string.encoding
    end
    
    it 'should NOT change the length to the byte count for UTF-8 encoded strings.' do
      @unicode_string.encoding.should == Encoding.find("UTF-8")
      ss = SecureString.new(@unicode_string)
      ss.length.should < ss.bytesize
    end
    
    it 'should allow forced transcoding to binary' do
      ss = SecureString.new(@unicode_string)
      
      ss.encoding.should == Encoding.find("UTF-8")
      ss.force_encoding("Binary")
      ss.encoding.should == Encoding.find("ASCII-8BIT")
      @unicode_string.encoding.should == Encoding.find("UTF-8")
    end
    
  end
  
end