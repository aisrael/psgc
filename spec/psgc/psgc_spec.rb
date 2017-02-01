require 'spec_helper'

describe PSGC do
  it 'is a module' do
    should be_kind_of Module
  end
  describe '.DATA_DIR' do
    it 'is a directory' do
      File.directory?(PSGC::DATA_DIR).should be true
    end
  end
  describe '::Region' do
    it 'is a class' do
      PSGC::Region.should be_kind_of Class
    end
    it 'is also a factory method' do
      PSGC::Region[1].should be_kind_of PSGC::Region
    end
  end
end
