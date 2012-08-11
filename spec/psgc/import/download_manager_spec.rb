require 'spec_helper'

require 'digest/md5'

require 'psgc/import'

describe PSGC::Import::DownloadManager do
  
  let(:src) { 'test.html' }
  let(:target) { '/tmp/test.html'}

  subject { PSGC::Import::DownloadManager }
  
  before(:all) do
    PSGC::Import::Base.dir = '/tmp'
    PSGC::Import::Base.uri = 'http://localhost'
  end
  
  describe '.fetch' do
    it "should curl if file doesn't exist" do
      subject.should_receive(:already_there).with(src).and_return(false)
      subject.should_receive(:cmd).with('curl http://localhost/test.html > ' + target)
      subject.fetch(src)
    end

    it 'should not curl if file exists' do
      subject.should_receive(:already_there).with(src).and_return(true)
      subject.should_receive(:puts).with('/tmp/test.html already exists and matches expected hash, skipping')      
      subject.should_not_receive(:cmd)
      subject.fetch(src)
    end
  end
  
  describe '.already_there' do
    it 'should check if file exists' do
      File.should_receive(:exists?).with(target)
      subject.send(:already_there, src)
    end

    it 'should check if file exists' do
      PSGC::Import::DownloadManager::CHECKSUMS[src] = '55349b2c7e24a01cf5a37673ada5b0f1'

      digest = mock('digest')
      File.should_receive(:exists?).with(target).and_return(true)
      Digest::MD5.should_receive(:file).with(target).and_return(digest)
      digest.should_receive(:hexdigest).and_return('55349b2c7e24a01cf5a37673ada5b0f1')
      subject.send(:already_there, src).should be_true
    end
  end

  describe '.cmd' do
    it 'is equivalent to puts(s) then system(s)' do
      
      s = 'echo Hello World'
      subject.should_receive(:puts).with(s)
      subject.should_receive(:system).with(s)
      # bypass protected visibility
      subject.send :cmd, s
    end
  end
end