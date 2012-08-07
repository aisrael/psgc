require 'spec_helper'

require 'digest/md5'

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
  
  it 'has attribute :expected_md5' do
    should respond_to :expected_md5
  end
  
  let(:task) { PSGC::Import::Base.new }
  describe '#full_source' do
    it 'returns Base.uri + src' do
      PSGC::Import::Base.uri = 'http://localhost'
      task.src = 'test.html'
      task.full_source.should eq(URI('http://localhost/test.html'))
    end
  end

  describe '#fetch' do
    before(:all) do
      PSGC::Import::Base.dir = '/tmp'
      PSGC::Import::Base.uri = 'http://localhost'
      task.src = 'test.html'
    end
    
    it "should curl if file doesn't exist" do
      target = '/tmp/test.html'
      task.should_receive(:already_there).with(target).and_return(false)
      task.should_receive(:cmd).with('curl http://localhost/test.html > ' + target)
      task.fetch
    end

    it 'should not curl if file exists' do
      task.should_receive(:already_there).with('/tmp/test.html').and_return(true)
      task.should_receive(:puts).with('test.html already exists and matches expected hash, skipping')      
      task.should_not_receive(:cmd)
      task.fetch
    end
  end
  
  describe '#already_there' do
    before(:all) do
      PSGC::Import::Base.dir = '/tmp'
      PSGC::Import::Base.uri = 'http://localhost'
      task.src = 'test.html'
    end
    
    it 'should check if file exists' do
      target = '/tmp/test.html'
      File.should_receive(:exists?).with(target)
      task.send(:already_there, target)
    end

    it 'should check if file exists' do
      task.expected_md5 = '55349b2c7e24a01cf5a37673ada5b0f1'

      target = '/tmp/test.html'
      digest = mock('digest')
      File.should_receive(:exists?).with(target).and_return(true)
      Digest::MD5.should_receive(:file).with(target).and_return(digest)
      digest.should_receive(:hexdigest).and_return('55349b2c7e24a01cf5a37673ada5b0f1')
      task.send(:already_there, target).should be_true
    end
  end
  
  describe '#parse' do
    it 'should do something' do
      task.parse
    end
  end
  
  describe '#cmd' do
    it 'is equivalent to puts(s) then system(s)' do
      
      s = 'echo Hello World'
      task.should_receive(:puts).with(s)
      task.should_receive(:system).with(s)
      # bypass protected visibility
      task.send :cmd, s
    end
  end
end
