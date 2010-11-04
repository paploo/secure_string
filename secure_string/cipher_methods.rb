require 'openssl'

class SecureString < String
  module CipherMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      
      # A convenience method for generating random cipher keys and initialization
      # vectors.
      def cipher_keygen(cipher_name)
        cipher = OpenSSL::Cipher::Cipher.new(cipher_name)
        cipher.encrypt
        return [cipher.random_key, cipher.random_iv].map {|s| self.new(s)}
      end
      
      # A convenience method for generating a random key and init vector for AES keys.
      # Defaults to a key length of 256.
      def aes_keygen(key_len=256)
        return cipher_keygen("aes-#{key_len.to_i}-cbc")
      end
      
    end
    
    module InstanceMethods
      
      # Given an OpenSSL cipher name, a key, and initialization vector,
      # encrypt the data.
      #
      # Use OpenSSL::Cipher.ciphers to get a list of available cipher names.
      #
      # To generate a new key and iv, do the following:
      #   cipher = OpenSSL::Cipher::Cipher.new(cipher_name)
      #   cipher.encrypt
      #   key = cipher.random_key
      #   iv = cipher.random_iv
      def to_cipher(cipher_name, key, iv)
        cipher = OpenSSL::Cipher.new(cipher_name)
        cipher.encrypt # MUST set the mode BEFORE setting the key and iv!
        cipher.key = key
        cipher.iv = iv
        msg = cipher.update(self)
        msg << cipher.final
        return self.class.new(msg)
      end
      
      # Given an OpenSSL cipher name, a key, and an init vector,
      # decrypt the data.
      def from_cipher(cipher_name, key, iv)
        cipher = OpenSSL::Cipher.new(cipher_name)
        cipher.decrypt # MUST set the mode BEFORE setting the key and iv!
        cipher.key = key
        cipher.iv = iv
        msg = cipher.update(self)
        msg << cipher.final
        return self.class.new(msg)
      end
      
      # Given an AES key and initialization vector, AES encode the data.
      def to_aes(key, iv, key_len=256)
        return self.class.new( to_cipher("aes-#{key_len.to_i}-cbc", key, iv) )
      end
      
      # Given an AES key and init vector, AES decode the data.
      def from_aes(key, iv, key_len=256)
        return self.class.new( from_cipher("aes-#{key_len.to_i}-cbc", key, iv) )
      end
      
    end
    
  end
end