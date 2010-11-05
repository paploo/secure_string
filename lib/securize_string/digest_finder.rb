require 'digest'
require 'openssl'

module SecurizeString
  #  A Helper class to look-up digests easily.
  class DigestFinder
    DIGESTS = {
      'DSS'        => OpenSSL::Digest::DSS      ,
      'DSS1'       => OpenSSL::Digest::DSS1     ,
      'MD2'        => OpenSSL::Digest::MD2      ,
      'MD4'        => OpenSSL::Digest::MD4      ,
      'MD5'        => OpenSSL::Digest::MD5      ,
      'SHA'        => OpenSSL::Digest::SHA      ,
      'SHA-0'      => OpenSSL::Digest::SHA      ,
      'SHA0'       => OpenSSL::Digest::SHA      ,
      'SHA-1'      => OpenSSL::Digest::SHA1     ,
      'SHA1'       => OpenSSL::Digest::SHA1     ,
      'SHA-224'    => OpenSSL::Digest::SHA224   ,
      'SHA-256'    => OpenSSL::Digest::SHA256   ,
      'SHA-384'    => OpenSSL::Digest::SHA384   ,
      'SHA-512'    => OpenSSL::Digest::SHA512   ,
      'SHA224'     => OpenSSL::Digest::SHA224   ,
      'SHA256'     => OpenSSL::Digest::SHA256   ,
      'SHA384'     => OpenSSL::Digest::SHA384   ,
      'SHA512'     => OpenSSL::Digest::SHA512   ,
      'RIPEMD-160' => OpenSSL::Digest::RIPEMD160,
      'RIPEMD160'  => OpenSSL::Digest::RIPEMD160
    }.freeze
    
    # Returns the complete list of digest strings recognized by find.
    def self.digests
      @supported_digests = DIGESTS.keys.inject([]) {|a,v| a | [v.upcase, v.downcase]}.sort if @supported_digests.nil?
      return @supported_digests
    end
    
    # Returns the OpenSSL::Digest class that goes with a given argument.
    def self.find(obj)
      if( obj.kind_of?(OpenSSL::Digest) )
        klass = obj.class
      elsif( obj.kind_of?(Class) && (obj < OpenSSL::Digest) )
        klass = obj
      elsif( obj.kind_of?(Class) && (obj < Digest::Base) )
        klass = DIGESTS[obj.name.split('::').last.upcase]
      elsif( obj.kind_of?(Digest::Base) )
        klass = DIGESTS[obj.class.name.split('::').last.upcase]
      else
        klass = DIGESTS[obj.to_s.upcase]
      end
      
      raise ArgumentError, "Cannot convert to OpenSSL::Digest: #{obj.inspect}" if klass.nil?
      
      return klass
    end
  
  end
end