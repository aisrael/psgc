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
    subject { PSGC::Import::Base.uri }
    it 'is a URI' do 
      should be_a_kind_of URI 
    end    

    it "has a default value set (#{PSGC::Import::Base.uri})" do      
      should_not be_nil
    end

    it 'accepts an ordinary string, but converts it to a URI' do
      PSGC::Import::Base.uri = 'http://localhost'
      should be_a_kind_of URI
    end
  end
  
  
  describe '.dir' do
    subject { PSGC::Import::Base.dir }
    it { should eq(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'web', 'www.nscb.gov.ph'))) }
  end

  it 'has attribute :src' do
    should respond_to :src    
  end
  
  describe '#full_source' do
    let(:task) { PSGC::Import::Base.new }
    it 'returns Base.uri + src' do
      PSGC::Import::Base.uri = 'http://localhost'
      task.src = 'test.html'
      task.full_source.should eq(URI('http://localhost/test.html'))
    end
  end

  describe '#fetch' do    
    let(:task) { PSGC::Import::Base.new }
    it 'should execute curl' do
      PSGC::Import::Base.dir = 'tmp'
      PSGC::Import::Base.uri = 'http://localhost'
      task.src = 'test.html'
      task.should_receive(:puts).with("curl http://localhost/test.html > tmp/test.html")
      task.should_receive(:system).with("curl http://localhost/test.html > tmp/test.html")
      task.fetch
    end
  end
end
