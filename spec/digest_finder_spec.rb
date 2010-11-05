require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Digest Finder" do
  
  it 'should give a list of digests' do
    digests = SecurizeString::DigestFinder.digests
    digests.should be_kind_of(Array)
    digests.should_not be_empty
  end
  
  it 'should list both upcase and downcase versions of each digest, just like OpenSSL::Cipher::ciphers' do
    digests = SecurizeString::DigestFinder.digests
    lower = digests.select {|d| d == d.downcase}
    upper = digests.select {|d| d == d.upcase}
    
    lower.length == upper.length
    (lower.length * 2) == digests.length
  end
  
  it 'should find an OpenSSL::Digest instance for a string' do
    SecurizeString::DigestFinder.find('SHA-256').should == OpenSSL::Digest::SHA256
    SecurizeString::DigestFinder.find('sha-256').should == OpenSSL::Digest::SHA256
    SecurizeString::DigestFinder.find('sha256').should  == OpenSSL::Digest::SHA256
    SecurizeString::DigestFinder.find('SHA256').should  == OpenSSL::Digest::SHA256
    
    lambda{ SecurizeString::DigestFinder.find('foobar') }.should raise_error(ArgumentError)
  end
  
  it 'should pass through a valid OpenSSL::Digest instance' do
    SecurizeString::DigestFinder.find(OpenSSL::Digest::SHA256).should == OpenSSL::Digest::SHA256
  end
  
  it 'should instantiate an OpenSSL::Digest class' do
    digest_obj = OpenSSL::Digest::SHA256.new
    SecurizeString::DigestFinder.find(digest_obj).should == OpenSSL::Digest::SHA256
  end
  
  it 'should instantiate a Digest class' do
    SecurizeString::DigestFinder.find(Digest::SHA256).should == OpenSSL::Digest::SHA256
  end
  
  it 'sould convert a Digest instance' do
    digest_obj = Digest::SHA256.new
    
    SecurizeString::DigestFinder.find(digest_obj).should == OpenSSL::Digest::SHA256
  end
  
end