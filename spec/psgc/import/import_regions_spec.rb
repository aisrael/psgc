require 'spec_helper'

require 'psgc/import'

describe PSGC::Import::ImportRegions do
  it 'initializes src to \'listreg.asp\'' do
    subject.src.should eq('listreg.asp')
  end
  it "#full_source == #{PSGC::Import::Base.uri}listreg.asp" do
    subject.full_source.should eq(PSGC::Import::Base.uri + 'listreg.asp')
  end
end
