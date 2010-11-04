require 'openssl'

class SecureString < String
  module RSAMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      # A convenience method for generating random public/private RSA key pairs.
      # Defaults to a key length of 2048, as 1024 is starting to be phased out
      # as the standard for secure communications.
      #
      # Returns the private key first, then the public key.  Returns them in PEM file
      # format by default, as this is most useful for portability.  DER format can
      # be explicitly specified with the second argument.
      #
      # For advanced usage of keys, instantiate an OpenSSL::PKey::RSA object
      # passing the returned key as the argument to +new+.  This will allow
      # introspection of common parameters such as p, q, n, e, and d.
      def rsa_keygen(key_len=2048, format = :pem)
        private_key_obj = OpenSSL::PKey::RSA.new(key_len.to_i)
        public_key_obj = private_key_obj.public_key
        formatting_method = (format == :der ? :to_der : :to_pem)
        return [private_key_obj, public_key_obj].map {|k| self.new( k.send(formatting_method) )}
      end
      
    end
    
    module InstanceMethods
      
      # Given an RSA public key, it RSA encrypts the data string.
      #
      # Note that the key must be 11 bytes longer than the data string or it doesn't
      # work.
      def to_rsa(public_key)
        key = OpenSSL::PKey::RSA.new(public_key)
        return self.class.new( key.public_encrypt(self) )
      end
      
      # Given an RSA private key, it decrypts the data string back into the original text.
      def from_rsa(private_key)
        key = OpenSSL::PKey::RSA.new(private_key)
        return self.class.new( key.private_decrypt(self) )
      end
      
      # Signs the given message using hte given private key.
      #
      # By default, signs using SHA256, but another digest object can be given.
      def sign(private_key, digest_obj=OpenSSL::Digest::SHA256.new)
        digest_obj = (digest_obj.kind_of?(Class) ? digest_obj.new : digest_obj)
        key = OpenSSL::PKey::RSA.new(private_key)
        return self.class.new( key.sign(digest_obj, self) )
      end
      
      # Verifies the given signature matches the messages digest, using the
      # signer's public key.
      #
      # By default, verifies using SHA256, but another digest object can be given.
      def verify?(public_key, signature, digest_obj=OpenSSL::Digest::SHA256.new)
        digest_obj = (digest_obj.kind_of?(Class) ? digest_obj.new : digest_obj)
        key = OpenSSL::PKey::RSA.new(public_key)
        return key.verify(digest_obj, signature.to_s, self)
      end
      
    end
    
  end
end