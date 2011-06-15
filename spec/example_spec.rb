

describe "Examples" do
  
  it 'should perform the basic usage example' do
    
    ss = SecureString.new("Hello World!")
    ss.to_s.should == "Hello World!"
    ss.inspect.should == "<48656c6c6f20576f726c6421>"
    
    ss.to_hex.should == "48656c6c6f20576f726c6421"
    ss.to_i.should == 22405534230753928650781647905
    ss.to_base64.should == "SGVsbG8gV29ybGQh\n"
    
    ss1 = SecureString.new("Hello World!", :type => :data)
    ss2 = SecureString.new("48656c6c6f20576f726c6421", :type => :hex)
    ss3 = SecureString.new(22405534230753928650781647905, :type => :int)
    ss4 = SecureString.new("SGVsbG8gV29ybGQh", :type => :base64)
    
    ss1.should == ss
    ss2.should == ss
    ss3.should == ss 
    ss4.should == ss 
  end
  
  it 'should perform the base64 example' do
    SecureString.new("Hello World!").to_base64.should == "SGVsbG8gV29ybGQh\n"
    
    (SecureString.new("SGVsbG8gV29ybGQh", :type => :base64) == "Hello World!").should be_true
    (SecureString.new("SGVsbG8gV29ybGQh") == "Hello World!"                  ).should be_false
    (SecureString.new("SGVsbG8gV29ybGQh").from_base64 == "Hello World!"      ).should be_true
  end
  
  it 'should perform digest example' do
    ss = SecureString.new("Hello World!")
    ss.to_md5.to_hex.should == "ed076287532e86365e841e92bfc50d8c"
    ss.to_sha1.to_hex.should == "2ef7bde608ce5404e97d5f042f95f89f1c232871"
    ss.to_sha256.to_hex.should == "7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069"
    ss.to_digest(OpenSSL::Digest::SHA512).to_hex.should == "861844d6704e8573fec34d967e20bcfef3d424cf48be04e6dc08f2bd58c729743371015ead891cc3cf1c9d34b49264b510751b1ff9e537937bc46b5d6ff4ecc8"
  end
  
  it 'should perform the cipher example' do
    # Generate a random key and initialization vector.
    key, iv = SecureString.aes_keygen
    
    # Now encrypt a message:
    message = SecureString.new("Hello World!")
    cipher_text = message.to_aes(key, iv)
    
    # Now decrypt the message:
    decoded_text = cipher_text.from_aes(key, iv)
    
    decoded_text.should == message
    cipher_text.should_not == message
  end
  
  if( RUBY_VERSION >= '1.9.0' )
    it 'should perform the char encoding example' do
      s = "Resum\u00E9"
      s.encoding.should == Encoding.find("UTF-8")
      s.length.should == 6
      s.bytesize.should == 7
    
      s = "Resum\u00E9"
      s.force_encoding('BINARY')
      s.encoding.should == Encoding.find("ASCII-8BIT")
      s.length.should == 7
      s.bytesize.should == 7
    
      s = "Resum\u00E9"
      b = s.dup.force_encoding('BINARY')
      (s == b).should be_false
      (s.bytes.to_a == b.bytes.to_a).should be_true
    end
  end
  
end