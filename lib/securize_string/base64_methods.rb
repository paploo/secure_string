require 'base64'

module SecurizeString
  # Adds methods for Base64 conversion.
  # See Base64Methods::InstanceMethods for more details.
  module Base64Methods
    
    def self.included(mod)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds instance methods for Base64 support via inclusion of
    # SecurizeString::Base64Methods to a class.
    module InstanceMethods
      
      # Encodes to Base64.
      #
      # By deault, this is the normal RFC 2045 Base64 encoding.
      #
      # If the <tt>url_safe</tt> option is set to true, then the RFC 4648
      # encoding is used, which uses a slightly different encoding mechanism
      # which is sometimes compatible, but often incompatible with RFC 2045.
      #
      # If the <tt>nobreak</tt> option is set to true, all line feeds are
      # removed from the input.
      def to_base64(opts={})
        raise ArgumentError, "__method__ expects an argument hash but got #{opts.class.name}" unless opts.kind_of?(Hash)
        data = (opts[:url_safe] ? Base64.urlsafe_encode64(self) : Base64.encode64(self))
        data.delete!("\n\r") if opts[:no_break] # Delete on \n and \r is about 3x faster than gsub on /\s+/.
        return self.class.new(data)
      end
      
      # Decodes from base64.
      #
      # By default, this decodes the normal RFC 2045 Base64.
      #
      # If the <tt>url_safe</tt> option is set to true, then it decodes the
      # RFC 4648 encoding, which uses a slightly different encoding mechanism
      # which is sometimes compatible, but often incompatible with RFC 2045.
      def from_base64(opts={})
        raise ArgumentError, "__method__ expects an argument hash but got #{opts.class.name}" unless opts.kind_of?(Hash)
        string = (opts[:url_safe] ? Base64.urlsafe_decode64(self) : Base64.decode64(self))
        return self.class.new(string)
      end
      
    end
    
  end
end