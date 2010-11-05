class SecureString < String
  # Adds the base methods necessary to make String or a String subclass handle
  # binary data better.
  # See BinaryStringDataMethods::ClassMethods and BinaryStringDataMethods::InstanceMethods for more deatils.
  module BinaryStringDataMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds basic binary data class methods to String or a String subclass, via
    # an include of SecureString::BinaryStringDataMethods
    module ClassMethods
      
      # Creates a data string from one many kinds of values:
      # [:data] (default) The passed string value is directly used.
      # [:hex] Initialize using a hexidecimal string.
      # [:int] Initialize using the numeric value of the hexidecimal string.
      # [:base64] Initialize using the given base64 encoded data.
      def parse_data(mode = :data, value)
        case mode
        when :hex
          hex_string = value.to_s
          data_string = [hex_string].pack('H' + hex_string.bytesize.to_s)
        when :data
          data_string = value.to_s
        when :int
          data_string = self.send(__method__, :hex, value.to_i.to_s(16))
        when :base64
          data_string = Base64.decode64(value.to_s)
        end
        
        return data_string
      end
      
    end
    
    # Adds basic binary data instance methods to String or a String subclass, via
    # an include of SecureString::BinaryStringDataMethods.
    module InstanceMethods
      
      # Override the default inspect to return the hexidecimal
      # representation of the data contained in this string.
      def inspect
        return "<#{to_hex}>"
      end
      
      # Returns the hexidecimal string representation of the data.
      def to_hex
        return (self.to_s.empty? ? '' : self.to_s.unpack('H' + (self.to_s.bytesize*2).to_s)[0])
      end
      
      # Returns the data converted from hexidecimal into an integer.
      # This is usually as a BigInt.
      #
      # WARNING: If the data string is empty, then this returns -1, as there is no
      # integer representation of the absence of data.
      def to_i
        return (self.to_s.empty? ? -1 : to_hex.hex)
      end
      
    end
    
  end
end