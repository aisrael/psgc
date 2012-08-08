require 'spec_helper'

describe PSGC do
  it 'is a module' do
    should be_kind_of Module
  end
  describe '.DATA_DIR' do
    it 'is a directory' do
      File.directory?(PSGC::DATA_DIR).should be_true
    end
  end
end
