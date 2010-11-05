require 'base64'

require_relative 'secure_string/binary_string_data_methods'
require_relative 'secure_string/digest_methods'
require_relative 'secure_string/base64_methods'
require_relative 'secure_string/cipher_methods'
require_relative 'secure_string/rsa_methods'

# SecureString is a String subclass whose emphasis is on byte data rather than
# human readable strings. class gives a number of conveniences, such
# as  easier viewing of the byte data as hex, digest methods, and encryption
# and decryption methods.
class SecureString < String
  include BinaryStringDataMethods
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
    data_string = self.class.parse_data(mode, value)
    self.replace( data_string )
  end
  
end