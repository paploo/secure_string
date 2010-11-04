require 'base64'

class SecureString < String
  module Base64Methods
    
    def self.included(mod)
      mod.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
      # Encodes to Base64.  By default, the output is made URL safe, which means all
      # newlines are stripped out.  If you want standard formatted Base64 with
      # newlines, then call this method with url_safe as false.
      def to_base64(url_safe = true)
        encoded_data = (url_safe ? Base64.urlsafe_encode64(self) : Base64.encode64(self))
        return self.class.new( encoded_data )
      end
      
      # Decode self as a Base64 data string and return the result.
      def from_base64
        return self.class.new( Base64.decode64(self) )
      end
      
    end
    
  end
end