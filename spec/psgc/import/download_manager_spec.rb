require 'spec_helper'

require 'digest/md5'

require 'psgc/import'

describe PSGC::Import::DownloadManager do

  let(:src) { 'test.html' }
  let(:full_target) { '/tmp/test.html'}

  subject { PSGC::Import::DownloadManager }

  around(:each) do |e|
    original_dir = PSGC::Import::Base.dir
    PSGC::Import::Base.dir = '/tmp'
    PSGC::Import::Base.uri = 'http://localhost'
    e.run
    PSGC::Import::Base.dir = original_dir
  end

  describe '.fetch' do
    it "should curl if file doesn't exist" do
      subject.should_receive(:already_there).with(src, full_target).and_return(false)
      subject.should_receive(:cmd).with('curl -m 60 "http://localhost/test.html" > ' + full_target).and_return(true)
      subject.send(:fetch, src, src)
    end

    it 'should not curl if file exists' do
      subject.should_receive(:already_there).with(src, full_target).and_return(true)
      subject.should_receive(:puts).with('test.html already exists and matches expected hash, skipping')
      subject.should_not_receive(:cmd)
      subject.send(:fetch, src, src)
    end
  end

  describe '.already_there' do
    it 'should check if file exists' do
      File.should_receive(:exists?).with(full_target)
      subject.send(:already_there, src, full_target)
    end

    it 'should check if file exists' do
      PSGC::Import::DownloadManager::CHECKSUMS[src] = '55349b2c7e24a01cf5a37673ada5b0f1'

      digest = double('digest')
      File.should_receive(:exists?).with(full_target).and_return(true)
      Digest::MD5.should_receive(:file).with(full_target).and_return(digest)
      digest.should_receive(:hexdigest).and_return('55349b2c7e24a01cf5a37673ada5b0f1')
      subject.send(:already_there, src, full_target).should be true
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
