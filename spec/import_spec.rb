require 'spec_helper'

describe PSGC::Import do
  it 'is a module' do
    should be_kind_of Module
  end
end

describe PSGC::Import::Base do
  describe '.uri' do
    it 'responds to uri' do
      PSGC::Import::Base.uri.should_not be_nil
      PSGC::Import::Base.uri.should be_a_kind_of URI
    end    
  end

  it 'responds to src' do
    should respond_to :src
  end
end

describe PSGC::Import::ListReg do
  
end