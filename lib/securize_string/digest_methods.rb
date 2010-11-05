require 'openssl'
require_relative 'digest_finder'
  
module SecurizeString
  # Adds methods for OpenSSL::Digest support.
  # See DigestMethods::ClassMethods and DigestMethods::InstanceMethods for more details.
  module DigestMethods
    def self.included(mod)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds instance methods for OpenSSL::Digest support via inclusion of
    # SecurizeString::DigestMethods to a class.
    module ClassMethods
      
      # Returns a list of supported digests.  These can be passed directly into
      # the cipher methods.
      def supported_digests
        return DigestFinder.digests
      end
      
    end
    
    # Adds instance methods for OpenSSL::Digest support via inclusion of
    # SecurizeString::DigestMethods to a class.
    module InstanceMethods
      
      # Returns the digest of the byte string as a SecureString using the passed
      # digest from the list of digests in +supported_digests+.
      def to_digest(digest)
        digest_obj = DigestFinder.find(digest).new
        return self.class.new( digest_obj.digest(self) )
      end
      
      # Returns the MD5 of the byte string as a SecureString.
      def to_md5
        return to_digest('MD5')
      end
      
      # Returns the SHA1 of the byte string as SecureString
      def to_sha1
        return to_digest('SHA-1')
      end
      
      # Returns the SHA2 of the byte string as a SecureString.
      #
      # By default, this uses the 256 bit SHA2, but the optional arugment allows
      # specification of which bit length to use.
      def to_sha2(length=256)
        if [224,256,384,512].include?(length)
          digest = "SHA-#{length}"
          return to_digest( digest )
        else
          raise ArgumentError, "Invalid SHA2 length: #{length}"
        end
      end
      
      # Returns the SHA2 256 of the data string.  See +to_sha2+.
      def to_sha256
        return to_sha2(256)
      end
      
      # Returns the SHA2 512 of the data string.  See +to_sha2+.
      def to_sha512
        return to_sha2(512)
      end
      
    end
    
  end
end