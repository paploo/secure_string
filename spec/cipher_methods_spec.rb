describe "SecureString" do

  describe "Cipher Methods" do
    
    describe "Keygen" do
      
      it 'should provide a keygen helper' do
        SecureString.should respond_to(:cipher_keygen)
      end
      
      it 'should provide generated keys as a SecureString class' do
        key, iv = SecureString.cipher_keygen('DES')
        
        key.should_not be_nil
        iv.should_not be_nil
        
        key.should be_kind_of(SecureString)
        iv.should be_kind_of(SecureString)
      end
      
      it 'should provide an AES keygen helper' do
        SecureString.should respond_to(:aes_keygen)
      end
      
      it 'should provide generated AES keysas a SecureString class' do
        key, iv = SecureString.aes_keygen
        
        key.should_not be_nil
        iv.should_not be_nil
        
        key.should be_kind_of(SecureString)
        iv.should be_kind_of(SecureString)
      end
      
      it 'should provide AES keys of various bit lengths' do
        [128,192,256].each do |bits|
          key, iv = SecureString.aes_keygen(bits)
          (key.bytesize * 8).should == bits
        end
      end
      
      it 'should raise an exception in an invalid AES bit length' do
        lambda {SecureString.aes_keygen(1234)}.should raise_error
      end
      
      it 'should default to a 256 bit AES key' do
        key, iv = SecureString.aes_keygen
        (key.bytesize * 8).should == 256
      end
      
      it 'should provide a list of supported ciphers' do
        SecureString.should respond_to(:supported_ciphers)
        SecureString.supported_ciphers.should be_kind_of(Array)
      end
      
    end
    
    describe "Cipher" do
      
      before(:all) do
        @cipher = "DES"
        @key = SecureString.new("4f42383e091ffc44", :type => :hex)
        @iv = SecureString.new("0b9299d6c2cb5003", :type => :hex)
        @message = SecureString.new("We the People of the United States, in Order to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America.")
        @encoded_message = SecureString.new("cfe8245b2c1f3f789b8ab78930c9582d1fead6792d8fe7efd418ba06d7da4e96f8525e8b437cf29af71ec66801c2031292fc17d88f5aaa9c776b3ca048169b48394e05d5ae6cbba5c78461a25bc3d5abc646f5f760e3a159b8448d79eed80a209473ca67536ebf417a24f05cf029e9e3ca5b1fb22e4e03427705d79b622d720c7d64cf3621319581a1a89b4cbb630611eea29cbd2c48caef0cf774ea0218b16d600cb4c025dcae177b702040bd7c62569bbda33f8e775dbadba4154074f482385c56449882efa31b908dfe5be17d8c0d220fd99414a78f6ce3cfee007fbd5dfc7fd50c343e6118d1a9174bb75db7c5adbaa558010f56571d087982ae791960c31041bae08adfa4d1a88f457897e38bd56a7e92234d21c8742fa577878b2d65500877d2f910d1fdbb5460afa73642778de8bd4442981baa93a481482f1cfb90fa85025ddf8588ecc7", :type => :hex)
      end
      
      it 'should encode to a SecureString' do
        @message.to_cipher(@cipher, @key, @iv).should be_kind_of(SecureString)
      end
      
      it 'should encode with a given cipher and key' do
        encoded_message = @message.to_cipher(@cipher, @key, @iv)
        encoded_message.should == @encoded_message
      end
      
      it 'should decode to a secure string' do
        @encoded_message.from_cipher(@cipher, @key, @iv).should be_kind_of(SecureString)
      end
      
      it 'should decode with a given cipher and key' do
        decoded_message = @encoded_message.from_cipher(@cipher, @key, @iv)
        decoded_message.should == @message
      end
      
    end
    
    describe "AES" do
      
      before(:all) do
        @key = SecureString.new("83f8577c1bc406e85ceeebc166c9fd4d087670de792b0d957c58f1beae6fb514", :type => :hex)
        @iv = SecureString.new("778c1086b5daf809e7abadde6995219d", :type => :hex)
        @message = SecureString.new("We the People of the United States, in Order to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America.")
        @encoded_message = SecureString.new("1fee4d01d33daf50915dc4b7aaf8b536f3b19ee9798b21200d475925460fd3aabc581d89e560b7b826e6017e02911687425d9c4a781d8e03a9d75dab5a85191f86b11fb74063133c3952201a8f2089afb0e298e29fe8becbe93ce110073b9abb968a268857aaabd94caa760fa402ce803f8643ad8870e77714b093e9ea09a4ad9d7e056836939f614a61f6b3e09057bc05f13432aa53cfc7de59d41a121f9fcb7c51825da2615c48debff6ed0fbaa0c85594aef54e11b73b8766f6e56d2cf7488909c14272e846cccca0008599bae334c5d404c122d286dcf04eec7b7711978686a66182f53e569297b91c25100ecfdad1f02de444c4de8f9d04067e885a2a17cad707b51ea8c2e8a15051138de617f8864cca8a4d201246a97b95cee5f78f742aace79629e03498f63b6385cff64d53a0425f7f52c6a8ba65771e043590b61191804fe91760e617412d842831928e57", :type => :hex)
      end
      
      it 'should encode to a SecureString' do
        @message.to_aes(@key, @iv).should be_kind_of(SecureString)
      end
      
      it 'should encode with a key' do
        encoded_message = @message.to_aes(@key, @iv)
        encoded_message.should == @encoded_message
      end
      
      it 'should decode to a secure string' do
        @encoded_message.from_aes(@key, @iv).should be_kind_of(SecureString)
      end
      
      it 'should decode with a key' do
        decoded_message = @encoded_message.from_aes(@key, @iv)
        decoded_message.should == @message
      end
      
      it 'should encode and decode from a non 256 bit key' do
        key, iv = SecureString.aes_keygen(128)
        encoded_message = @message.to_aes(key, iv)
        decoded_message = encoded_message.from_aes(key, iv)
        
        encoded_message.should_not == decoded_message
        decoded_message.should == @message
      end
      
    end
    
  end
  
end