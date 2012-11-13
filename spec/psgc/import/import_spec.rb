require 'spec_helper'

require 'digest/md5'

require 'psgc/import'

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

  it { should respond_to :src }

  let(:task) { PSGC::Import::Base.new 'src' }

  describe '#target' do
    it 'should be \'Base.dir/src\'' do
      task.send(:target).should eq(File.join(PSGC::Import::Base.dir, 'src'))
    end
  end

  describe '#parse' do
    it 'should do something' do
      task.parse
    end
  end

  describe '#fetch' do
    it 'should delegate to DownloadManager' do
      PSGC::Import::DownloadManager.should_receive(:fetch).with('src')
      task.fetch
    end
  end
end
