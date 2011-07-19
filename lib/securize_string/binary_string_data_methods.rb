require 'base64'

module SecurizeString
  # Adds base methods that help in interpreting the binary data represented by the String value of an object.
  # See BinaryStringDataMethods::ClassMethods and BinaryStringDataMethods::InstanceMethods for more deatils.
  module BinaryStringDataMethods
    
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
    # Adds basic binary data class methods via an include of SecurizeString::BinaryStringDataMethods.
    module ClassMethods
      
      # Creates a data string from one many kinds of values:
      # [:data] (default) The passed string value is directly used.
      # [:hex] Initialize using a hexidecimal string.
      # [:int] Initialize using the numeric value of the hexidecimal string.
      # [:base64] Initialize using the given base64 encoded data.
      # To specify a value kind, use the :type option.
      def parse_data(value, opts={})
        raise ArgumentError, "The first argument is a symbol; setting the input data type this way is no longer supported. Call `#{self.class.name}.new('string', :type => #{value.inspect})' instead.", caller if value.kind_of?(Symbol)
        data_type_hint = (opts[:data_type_hint] || opts[:type] || :data).to_sym
        case data_type_hint
        when :hex
          hex_string = value.to_s.delete('^0-9a-fA-F')
          data_string = [hex_string].pack('H*')
        when :data
          data_string = value.to_s
        when :int
          data_string = self.send(__method__, value.to_i.to_s(16), :type => :hex)
        when :base64
          data_string = Base64.decode64(value.to_s)
        else
          raise ArgumentError, "Unrecognized data type hint: #{data_type_hint.inspect}"
        end
        
        return data_string
      end
      
    end
    
    # Adds basic binary data instance methods via an include of SecurizeString::BinaryStringDataMethods.
    module InstanceMethods
      
      # Returns the hexidecimal string representation of the data.
      def data_to_hex
        return (self.to_s.empty? ? '' : self.to_s.unpack('H*')[0])
      end
      
      # Returns the data converted from hexidecimal into an integer.
      # This is usually as a BigInt.
      #
      def data_to_i
        return (self.to_s.empty? ? 0 : self.data_to_hex.hex)
      end
      
    end
    
  end
end