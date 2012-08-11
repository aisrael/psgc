require 'spec_helper'

require 'psgc/import'

describe PSGC::Import::ImportRegions do
  it 'initializes src to \'listreg.asp\'' do
    subject.src.should eq('listreg.asp')
  end
end
