#encoding: UTF-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe "ByteString" do
  
  before(:each) do
    @unicode_string = "A resumé for the moose; Eine Zusammenfassung für die Elche; Резюме для лосей; アメリカヘラジカのための概要; Μια περίληψη για τις άλκες; 麋的一份簡歷; Un résumé pour les orignaux."
  end
  
  it 'should force encoding to ASCII-8BIT' do
    @unicode_string.encoding.should == Encoding.find('UTF-8')
    bs = ByteString.new(@unicode_string)
    bs.encoding.should == Encoding.find('ASCII-8BIT')
  end
  
  it 'should have the same byte value as a UTF-8 encoded string' do
    ss = SecureString.new(@unicode_string)
    bs = ByteString.new(@unicode_string)
    
    ss.encoding.should == Encoding.find('UTF-8')
    bs.encoding.should == Encoding.find('ASCII-8BIT')
    
    bs.to_hex.should == ss.to_hex
  end
  
end