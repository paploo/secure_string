# Rake require fancy footwork is for bundler's benefit.
begin
  Rake
rescue NameError
  require 'rake'
end

Gem::Specification.new do |s|
  s.name = 'secure_string'
  s.version = '1.1.2'
  
  s.required_ruby_version = '>= 1.9.0'
  
  s.authors = ['Jeff Reinecke']
  s.email = 'jeff@paploo.net'
  s.homepage = 'http://www.github.com/paploo/secure_string'
  
  s.require_paths = ['lib']
  s.licenses = ['BSD']
  s.files = FileList['README.rdoc', 'LICENSE.txt', 'Rakefile', 'lib/**/*', 'spec/**/*']
  
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  
  s.summary = 'A String subclass for simple handling of binary data and encryption.'
  s.description = <<-DESC
    A String subclass to simplify handling of:
      1. Binary data, including HEX encoding and Bin64 encoding.
      2. Encryption such as RSA, AES, and digest methods such as SHA and MD5.
  DESC
end