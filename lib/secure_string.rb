require File.join(File.dirname(__FILE__), 'securize_string')

# SecureString is a String subclass whose emphasis is on byte data rather than
# human readable strings. class gives a number of conveniences, such
# as  easier viewing of the byte data as hex, digest methods, and encryption
# and decryption methods.
class SecureString < String
  include SecurizeString
  
  # Creates the string from one many kinds of values:
  # [:data] (default) The passed string value is directly used.
  # [:hex] Initialize using a hexidecimal string.
  # [:int] Initialize using the numeric value of the hexidecimal string.
  # [:base64] Initialize using the given base64 encoded data.
  # To specify a value kind, pass the :type option.
  def initialize(value, opts={})
    raise ArgumentError, "The first argument is a symbol; setting the input data type this way is no longer supported. Call `#{self.class.name}.new('string', :type => #{value.inspect})' instead.", caller if value.kind_of?(Symbol)
    data_string = self.class.parse_data(value, opts)
    self.replace(data_string)
  end
  
  # Override the default to_i method to return the integer value of the data
  # contained in the string, rather than the parsed value of the characters.
  def to_i
    return data_to_i
  end
  
  # Add a method to convert the internal binary data into a hex string.
  def to_hex
    return data_to_hex
  end
  
  # Add a method to convert the internal binary dat into an escaped hex string
  # which is suitable for pasting into Ruby and Javascript source files.
  def to_escaped_hex
    return data_to_escaped_hex
  end
  
  # Override the default inspect to return the hexidecimal
  # representation of the data contained in this string.
  def inspect
    return "<#{to_hex}>"
  end
  
end