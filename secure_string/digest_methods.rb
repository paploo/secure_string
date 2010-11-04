require 'openssl'
  
class SecureString < String
  module DigestMethods
    
    def self.included(mod)
      mod.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
      # Returns the digest of the byte string as a SecureString, using the passed OpenSSL object.
      def to_digest(digest_obj)
        return self.class.new( digest_obj.digest(self) )
      end
      
      # Returns the MD5 of the byte string as a SecureString.
      def to_md5
        return to_digest( OpenSSL::Digest::MD5.new )
      end
      
      # Returns the SHA2 of the byte string as a SecureString.
      #
      # By default, this uses the 256 bit SHA2, but the optional arugment allows
      # specification of which bit length to use.
      def to_sha2(length=256)
        if [224,256,384,512].include?(length)
          digest_klass = OpenSSL::Digest.const_get("SHA#{length}", false)
          return to_digest( digest_klass )
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