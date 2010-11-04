require 'base64'

require_relative 'secure_string/digest_methods'
require_relative 'secure_string/base64_methods'
require_relative 'secure_string/cipher_methods'
require_relative 'secure_string/rsa_methods'

# SecureString is a String subclass whose emphasis is on byte data rather than
# human readable strings. class gives a number of conveniences, such
# as  easier viewing of the byte data as hex, digest methods, and encryption
# and decryption methods.
class SecureString < String
  include Base64Methods
  include DigestMethods
  include RSAMethods
  include CipherMethods
  
  # Creates the string from one many kinds of values:
  # [:data] (default) The passed string value is directly used.
  # [:hex] Initialize using a hexidecimal string.
  # [:int] Initialize using the numeric value of the hexidecimal string.
  # [:base64] Initialize using the given base64 encoded data.
  def initialize(mode = :data, value)
    case mode
    when :hex
      hex_string = value.to_s
      data = [hex_string].pack('H' + hex_string.length.to_s)
    when :data
      data = value.to_s
    when :int
      data = self.send(__method__, :hex, value.to_i.to_s(16))
    when :base64
      data = Base64.decode64(value.to_s)
    end
    
    self.replace(data)
  end
  
  # Override the default String inspect to return the hexidecimal
  # representation of the data contained in this string.
  def inspect
    return "<#{to_hex}>"
  end
  
  # Returns the hexidecimal string representation of the data.
  def to_hex
    return (self.empty? ? '' : self.unpack('H' + (self.length*2).to_s)[0])
  end
  
  # Returns the data converted from hexidecimal into an integer.
  # This is usually as a BigInt.
  #
  # WARNING: If the data string is empty, then this returns -1, as there is no
  # integer representation of the absence of data.
  def to_i
    return (self.empty? ? -1 : to_hex.hex)
  end
  
end