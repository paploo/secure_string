require_relative 'securize_string/binary_string_data_methods'
require_relative 'securize_string/digest_methods'
require_relative 'securize_string/base64_methods'
require_relative 'securize_string/cipher_methods'
require_relative 'securize_string/rsa_methods'

module SecurizeString
  
  def self.included(mod)
    [
      BinaryStringDataMethods,
      Base64Methods,
      DigestMethods,
      RSAMethods,
      CipherMethods
    ].each do |mixin|
      mod.send(:include, mixin)
    end
  end
  
end