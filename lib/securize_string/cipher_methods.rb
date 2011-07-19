require 'openssl'

module SecurizeString
  # Adds methods for OpenSSL::Cipher support including AES encryption.
  # See CipherMethods::ClassMethods and CipherMethods::InstanceMethods for more details.
  module CipherMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds class methods for OpenSSL::Cipher support, including AES encryption,
    # via inclusion of SecurizeString::CipherMethods into a class.
    module ClassMethods
      
      # Returns a list of supported ciphers.  These can be passed directly into
      # the cipher methods.
      def supported_ciphers
        return OpenSSL::Cipher.ciphers
      end
      
      # A convenience method for generating random cipher keys and initialization
      # vectors.
      def cipher_keygen(cipher_name)
        cipher = OpenSSL::Cipher.new(cipher_name)
        cipher.encrypt
        return [cipher.random_key, cipher.random_iv].map {|s| self.new(s)}
      end
      
      # A convenience method for generating a cipher key from a passphrase
      # using PKCS5 v2 standards.  The key and the salt may be any string.
      #
      # This also derives a predictable initialization vector from the given
      # passphrase in a manor consistent with RFC2898, though it is better to
      # generate a random IV with each encryption of the same data if possible.
      #
      # Note that the OpenSSL::Cipher#pkcs5_keyivgen method is not PKCS5 v2
      # compliant, and therefore will not be implemented.
      def cipher_passphrase_keygen(cipher_name, passphrase, salt, iterations=2048)
        # The first pits of a PBKDF2 are the same wether I build the key and IV
        # at once, but when an IV is built in the RFC2898 standards, they do it
        # this way.
        cipher = OpenSSL::Cipher.new(cipher_name.to_s)
        cipher.encrypt
        key_and_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(passphrase.to_s, salt.to_s, iterations.to_i, cipher.key_len+cipher.iv_len)
        return [key_and_iv[0,cipher.key_len], key_and_iv[cipher.key_len, cipher.iv_len]].map {|s| self.new(s)}
      end
      
      # A convenience method for generating a random key and init vector for AES
      # encryption.
      #
      # Defaults to a key length of 256.
      def aes_keygen(key_len=256)
        return cipher_keygen("aes-#{key_len.to_i}-cbc")
      end
      
      # A convenience method for generating a key and init vector from a passphrase
      # for AES encryption.
      #
      # Defaults to a key length of 256.
      def aes_passphrase_keygen(key_len, passphrase, salt, iterations=2048)
        return cipher_passphrase_keygen("aes-#{key_len.to_i}-cbc", passphrase, salt, iterations)
      end
      
    end
    
    # Adds instance methods for OpenSSL::Cipher support, including AES encryption,
    # via inclusion of SecurizeString::CipherMethods into a class.
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
        msg = cipher.update(self.to_s)
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
        msg = cipher.update(self.to_s)
        msg << cipher.final
        return self.class.new(msg)
      end
      
      # Given an AES key and initialization vector, AES-CBC encode the data.
      #
      # Note that one normally never wants to use the same key and iv
      # combination on two different messages as this weakens the security.
      def to_aes(key, iv)
        key_len = (key.bytesize * 8)
        return self.class.new( to_cipher("aes-#{key_len}-cbc", key, iv) )
      end
      
      # Given an AES key and init vector, AES-CBC decode the data.
      def from_aes(key, iv)
        key_len = (key.bytesize * 8)
        return self.class.new( from_cipher("aes-#{key_len}-cbc", key, iv) )
      end
      
    end
    
  end
end