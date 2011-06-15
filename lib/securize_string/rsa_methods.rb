require 'openssl'

module SecurizeString
  # Adds methods for OpenSSL::PKey::RSA support.
  # See RSAMethods::ClassMethods and RSAMethods::InstanceMethods for more details.
  module RSAMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds class methods for OpenSSL::PKey::RSA support via inclusion of
    # SecurizeString::RSAMethods to a class.
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
      
      # A convenience method for extracting the private, public keypair from
      # a private key.
      #
      # Returns the same format as +rsa_keygen+, but takes the private key as
      # a string as a first argument.
      def separate_keys(pvt_key, format = :pem)
        private_key_obj = OpenSSL::PKey::RSA.new(pvt_key.to_s)
        public_key_obj = private_key_obj.public_key
        formatting_method = (format == :der ? :to_der : :to_pem)
        return [private_key_obj, public_key_obj].map {|k| self.new( k.send(formatting_method) )}
      end
      
    end
    
    # Adds instance methods for OpenSSL::PKey::RSA support via inclusion of
    # SecurizeString::RSAMethods to a class.
    module InstanceMethods
      
      # Given an RSA public key, it RSA encrypts the data string.
      #
      # Note that the key must be 11 bytes longer than the data string or it doesn't
      # work.
      def to_rsa(key)
        key = OpenSSL::PKey::RSA.new(key)        
        cipher_text = key.private? ? key.private_encrypt(self.to_s) : key.public_encrypt(self.to_s)
        return self.class.new(cipher_text)
      end
      
      # Given an RSA private key, it decrypts the data string back into the original text.
      def from_rsa(key)
        key = OpenSSL::PKey::RSA.new(key)
        plain_text = key.private? ? key.private_decrypt(self.to_s) : key.public_decrypt(self.to_s)
        return self.class.new(plain_text)
      end
      
      # Signs the given message using hte given private key.
      #
      # By default, verifies using SHA256, but another digest method can be given
      # using the list of DigestFinder supported digests.
      def sign(private_key, digest_method='SHA-256')
        digest_obj = DigestFinder.find(digest_method).new
        key = OpenSSL::PKey::RSA.new(private_key)
        return self.class.new( key.sign(digest_obj, self) )
      end
      
      # Verifies the given signature matches the messages digest, using the
      # signer's public key.
      #
      # By default, verifies using SHA256, but another digest method can be given
      # using the list of DigestFinder supported digests.
      def verify?(public_key, signature, digest_method='SHA-256')
        digest_obj = DigestFinder.find(digest_method).new
        key = OpenSSL::PKey::RSA.new(public_key)
        return key.verify(digest_obj, signature.to_s, self)
      end
      
      # Interpret the conetents of the string as an RSA key, and determine if it is public.
      #
      # Even though private keys contain all the information necessary to reconstitute
      # a public key, this method returns false.  This is in contrast to the
      # behavior of OpenSSL::PKey::RSA, which return true for both public and
      # private checks with a private key (since it reconstituted the public
      # key and it is available for use).
      def public_rsa_key?
        # There is an interesting bug I came across, where +public?+ can be true on a private key!
        return !private_rsa_key?
      end
      
      # Interpret the conents of the string as an RSA key, and determine if it is private.
      def private_rsa_key?
        key = OpenSSL::PKey::RSA.new(self.to_s)
        return key.private?
      end
      
      # Interpret the contents of hte string asn a RSA private key, and extract
      # the public key from it.  If the contents are not a private key, then it
      # will raise an exception.
      def extract_public_key(format = :pem)
        pvt, pub = self.class.separate_keys(self, format)
        return pub
      end
      
    end
    
  end
end