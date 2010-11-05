describe "SecureString" do

  describe "RSA Methods" do
    
    describe "Keygen" do
      
      it 'should generate a public/private key pair' do
        SecureString.should respond_to(:rsa_keygen)
      end
      
      it 'should generate key pairs of varying length' do
        [256, 512, 1024, 2048].each do |bits|
          pvt_key, pub_key = SecureString.rsa_keygen(bits)
          [pvt_key, pub_key].each do |key|
            key_obj = OpenSSL::PKey::RSA.new(key)
            # The bit length of the key is the bit length of the modulus, n.
            # It turns out that an OpenSSL::PKey::RSA object returns an
            # OpenSSL::BN object when you get the modulus, which has a nice
            # little method for getting the number of bytes it is long.
            key_length_in_bits = key_obj.n.num_bytes * 8
            key_length_in_bits.should == bits
          end
        end
      end
      
      it 'should default to a 2048 bit key' do
        pvt_key, pub_key = SecureString.rsa_keygen
        [pvt_key, pub_key].each do |key|
          key_obj = OpenSSL::PKey::RSA.new(key)
          # The bit length of the key is the bit length of the modulus, n.
          # It turns out that an OpenSSL::PKey::RSA object returns an
          # OpenSSL::BN object when you get the modulus, which has a nice
          # little method for getting the number of bytes it is long.
          key_length_in_bits = key_obj.n.num_bytes * 8
          key_length_in_bits.should == 2048
        end
      end
      
      it 'should return key pairs as SecureString instances' do
        pvt_key, pub_key = SecureString.rsa_keygen
        [pvt_key, pub_key].each do |key|
          key.should be_kind_of(SecureString)
        end
      end
      
      it 'should support both pem and der formats' do
        [:pem, :der].each do |format|
          pvt_key, pub_key = SecureString.rsa_keygen(512, format)
          [pvt_key, pub_key].each do |key|
            key_obj = OpenSSL::PKey::RSA.new(key)
            key.should == key_obj.send("to_#{format}".to_sym)
          end
        end
      end
      
      it 'should default to pem format' do
        pvt_key, pub_key = SecureString.rsa_keygen
        [pvt_key, pub_key].each do |key|
          key_obj = OpenSSL::PKey::RSA.new(key)
          key.should == key_obj.to_pem
        end
      end
      
    end
    
    describe "Encryption" do
      
      before(:all) do
        @key_length = 128
        @pvt_key = SecureString.new(:hex, "2d2d2d2d2d424547494e205253412050524956415445204b45592d2d2d2d2d0a4d47454341514143455143364c704764426d334a78495048513945345537443141674d424141454345474c62517a6e724a6652525762433365474b3561656b430a4351446d633569312f5669666277494a414d37536b4534554b7750624167682b7831316430564274395149494a4648372f346f784a364d4343474e646e3933330a4a43774d0a2d2d2d2d2d454e44205253412050524956415445204b45592d2d2d2d2d0a")
        @pub_key = SecureString.new(:hex, "2d2d2d2d2d424547494e20525341205055424c4943204b45592d2d2d2d2d0a4d426743455143364c704764426d334a78495048513945345537443141674d424141453d0a2d2d2d2d2d454e4420525341205055424c4943204b45592d2d2d2d2d0a")
        @message = SecureString.new("Hello")
      end
      
      it 'should encrypt and decrypt to a SecureString' do
        encrypted_message = @message.to_rsa(@pub_key)
        encrypted_message.should be_kind_of(SecureString)
        decrypted_message = encrypted_message.from_rsa(@pvt_key)
        decrypted_message.should be_kind_of(SecureString)
      end
      
      # We cannot independently test encryption because it changes everytime
      # thanks to padding generation.
      it 'should encrypt and decrypy a message' do
        encrypted_message = @message.to_rsa(@pub_key)
        (encrypted_message.bytesize * 8).should == @key_length
        
        decrypted_message = encrypted_message.from_rsa(@pvt_key)
        decrypted_message.should == @message
      end
      
    end
    
    
    describe "Verification" do
      
      before(:all) do
        @key_length = 1024
        @alice_pvt_key, @alice_pub_key = SecureString.rsa_keygen(@key_length)
        @bob_pvt_key, @bob_pub_key = SecureString.rsa_keygen(@key_length)
        
        @message = SecureString.new("Hello")
      end
      
      it 'should sign and verify a message using a private key' do
        # Alice encrypts a message for Bob and signs is.
        @encrypted_message = @message.to_rsa(@bob_pub_key)
        @signature = @encrypted_message.sign(@alice_pvt_key)
        
        # Verify it came from Alice.
        is_verified = @encrypted_message.verify?(@alice_pub_key, @signature)
        is_verified.should be_true
        
        # Verify it did not come from Bob.
        is_verified = @encrypted_message.verify?(@bob_pub_key, @signature)
        is_verified.should be_false
        
        # Bob should now decrypt it
        @decrypted_message = @encrypted_message.from_rsa(@bob_pvt_key)
        @decrypted_message.should == @message
      end
      
      it 'should default to signing with SHA-256' do
        encrypted_message = @message.to_rsa(@bob_pub_key)
        encrypted_message.sign(@alice_pvt_key).should == encrypted_message.sign(@alice_pvt_key, 'SHA-256')
      end
      
      it 'should allow signing with other digests' do
        encrypted_message = @message.to_rsa(@bob_pub_key)
        comparison_digest_method = 'SHA-256'
        ['SHA-512', 'MD5', 'SHA-1'].each do |digest_method|
          next if digest_method == comparison_digest_method
          signature = encrypted_message.sign(@alice_pvt_key, digest_method)
          signature.should_not == encrypted_message.sign(@alice_pvt_key, comparison_digest_method)
        end
      end
      
      it 'should allow passing the digest method as an instance, class, or string' do
        encrypted_message = @message.to_rsa(@bob_pub_key)
        [OpenSSL::Digest::SHA512, OpenSSL::Digest::SHA256, OpenSSL::Digest::MD5, OpenSSL::Digest::SHA1].each do |digest_klass|
          signature1 = encrypted_message.sign(@alice_pvt_key, digest_klass)
          signature2 = encrypted_message.sign(@alice_pvt_key, digest_klass.new)
          signature3 = encrypted_message.sign(@alice_pvt_key, digest_klass.name.split('::').last)
          signature2.should == signature1
          signature3.should == signature1
        end
      end
      
      it 'should work with Digest scoped digest classes' do
        encrypted_message = @message.to_rsa(@bob_pub_key)
        signature1 = encrypted_message.sign(@alice_pvt_key, Digest::SHA256)
        signature2 = encrypted_message.sign(@alice_pvt_key, OpenSSL::Digest::SHA256)
        signature1.should == signature2
      end
      
      it 'should work with Digest scoped digest instances' do
        encrypted_message = @message.to_rsa(@bob_pub_key)
        signature1 = encrypted_message.sign(@alice_pvt_key, Digest::SHA256.new)
        signature2 = encrypted_message.sign(@alice_pvt_key, OpenSSL::Digest::SHA256.new)
        signature1.should == signature2
      end
      
    end
    
  end
end