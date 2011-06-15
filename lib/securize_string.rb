[
  'binary_string_data_methods',
  'digest_methods',
  'base64_methods',
  'cipher_methods',
  'rsa_methods'
].each do |module_file_name|
  require File.join(File.dirname(__FILE__), 'securize_string', module_file_name)
end

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