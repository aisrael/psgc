require 'spec_helper'

describe PSGC::Region do
  describe '.REGION_DATA' do
    it 'is a file' do
      File.exists?(PSGC::Region::REGION_DATA).should be_true
    end
  end

  it 'has an :id' do
    should respond_to :id
  end

  it { should respond_to :name }

  it do
    should respond_to :provinces
    subject.should have_at_least(1).provinces
  end  

  describe '#provinces' do
    it 'is a collection of Province' do
      subject.provinces.should be_a Enumerable
      subject.provinces.first.should be_a PSGC::Province
    end
  end
end
