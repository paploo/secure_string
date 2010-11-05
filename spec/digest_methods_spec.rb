# Make sure to test that the cipher methods are from openssl and not jsut digest?

require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SecureString" do

  describe "Digest Methods" do
    
    describe "to_digest" do
      
      before(:all) do
        @openssl_digest_class_sample = [OpenSSL::Digest::MD5, OpenSSL::Digest::SHA1, OpenSSL::Digest::SHA256, OpenSSL::Digest::SHA512]
        @digest_class_sample = [Digest::MD5, Digest::SHA1, Digest::SHA256, Digest::SHA512]
        
        @message = SecureString.new("Hello World!")
        @message_md5_hex = "ed076287532e86365e841e92bfc50d8c"
        @message_sha512_hex = "861844d6704e8573fec34d967e20bcfef3d424cf48be04e6dc08f2bd58c729743371015ead891cc3cf1c9d34b49264b510751b1ff9e537937bc46b5d6ff4ecc8"
      end
      
      it 'should encode as a SecureString' do
        @message.to_digest(OpenSSL::Digest::MD5).should be_kind_of(SecureString)
        @message.to_digest(OpenSSL::Digest::SHA512).should be_kind_of(SecureString)
      end
      
      it 'should contain the raw value, not the hex value' do
        md5 = @message.to_digest(OpenSSL::Digest::MD5)
        md5.should_not == @message_md5_hex
        md5.to_hex.should == @message_md5_hex
        
        sha512 = @message.to_digest(OpenSSL::Digest::SHA512)
        sha512.should_not == @message_sha512_hex
        sha512.to_hex.should == @message_sha512_hex
      end
      
      it 'should take an OpenSSL::Digest class' do
        @openssl_digest_class_sample.each do |klass|
          @message.to_digest(klass).to_hex.should == klass.hexdigest(@message)
        end
      end
      
      it 'should take an OpenSSL::Digest instance' do
        @openssl_digest_class_sample.each do |klass|
          @message.to_digest(klass.new).to_hex.should == klass.hexdigest(@message)
        end
      end
      
      it 'should take a Digest class' do
        @digest_class_sample.each do |klass|
          @message.to_digest(klass).to_hex.should == klass.hexdigest(@message)
        end
      end
      
      it 'should take a Digest instance' do
        @digest_class_sample.each do |klass|
          @message.to_digest(klass.new).to_hex.should == klass.hexdigest(@message)
        end
      end
      
    end
    
    
    describe "Convenience Methods" do
      
      before(:all) do
        @message = SecureString.new("Hello World!")
        
        @hex_digests = {
          :md5 => "ed076287532e86365e841e92bfc50d8c",
          :sha1 => "2ef7bde608ce5404e97d5f042f95f89f1c232871",
          :sha256 => "7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069",
          :sha512 => "861844d6704e8573fec34d967e20bcfef3d424cf48be04e6dc08f2bd58c729743371015ead891cc3cf1c9d34b49264b510751b1ff9e537937bc46b5d6ff4ecc8"
        }
      end
      
      it 'should MD5' do
        @message.should respond_to(:to_md5)
        digest = @message.to_md5
        digest.should be_kind_of(SecureString)
        digest.to_hex.should == @hex_digests[:md5]
      end
      
      it 'should SHA1' do
        @message.should respond_to(:to_sha1)
        digest = @message.to_sha1
        digest.should be_kind_of(SecureString)
        digest.to_hex.should == @hex_digests[:sha1]
      end
      
      it 'should SHA2-256' do
        @message.should respond_to(:to_sha256)
        digest = @message.to_sha256
        digest.should be_kind_of(SecureString)
        digest.to_hex.should == @hex_digests[:sha256]
      end
      
      it 'should SHA2=512' do
        @message.should respond_to(:to_sha512)
        digest = @message.to_sha512
        digest.should be_kind_of(SecureString)
        digest.to_hex.should == @hex_digests[:sha512]
      end
      
      it 'should SHA2' do
        @message.should respond_to(:to_sha2)
        digest = @message.to_sha2
        digest.should be_kind_of(SecureString)
        digest.should == @message.to_sha2(256)
        
        digest = @message.to_sha2(256)
        digest.should_not == @hex_digests[:sha256]
        digest.to_hex.should == @hex_digests[:sha256]
        
        digest = @message.to_sha2(512)
        digest.should_not == @hex_digests[:sha512]
        digest.to_hex.should == @hex_digests[:sha512]
      end
      
    end
  end
  
end