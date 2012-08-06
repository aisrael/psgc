require 'spec_helper'

describe PSGC::Import do
  it 'is a module' do
    PSGC::Import.should be_kind_of Module
  end
  describe 'provides the following classes' do
    it 'PSGC::Import::Base' do
      PSGC::Import::Base.should be_kind_of Class
    end
  end
end

describe PSGC::Import::Base do
  describe '.uri' do

    it 'is a URI' do 
      PSGC::Import::Base.uri.should be_a_kind_of URI 
    end    

    it "has a default value set (#{PSGC::Import::Base.uri})" do      
      PSGC::Import::Base.uri.should_not be_nil
    end

    it 'accepts an ordinary string, but converts it to a URI' do
      PSGC::Import::Base.uri = 'http://localhost'
      PSGC::Import::Base.uri.should be_a_kind_of URI
    end

  end

  it 'responds to src' do
    should respond_to :src
  end
  
  it 'returns Base.uri + src as full_source' do
    PSGC::Import::Base.uri = 'http://localhost'
    import = PSGC::Import::Base.new
    import.src = 'test.html'
    import.full_source.should eq(URI('http://localhost/test.html'))
  end

end
