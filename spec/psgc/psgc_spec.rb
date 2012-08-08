require 'spec_helper'

describe PSGC do
  it 'is a module' do
    should be_kind_of Module
  end
  it 'defines DATA_DIR' do
    File.exists?(PSGC::DATA_DIR).should be_true
    File.directory?(PSGC::DATA_DIR).should be_true
  end
end
