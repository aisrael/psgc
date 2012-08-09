require 'spec_helper'

describe PSGC::Region do
  describe '.REGION_DATA' do
    it 'is a file' do
      File.exists?(PSGC::Region::REGION_DATA).should be_true
    end
  end
  
  describe '.all' do
    subject { PSGC::Region.all }
    it { should be_a Enumerable }
    it { subject.first.should be_a PSGC::Region }
  end

  it { should respond_to :id }
  it { should respond_to :code }
  it { should respond_to :name }
  it { should respond_to :provinces }
  it { should have_at_least(1).provinces }

  describe '#provinces' do
    it 'is a collection of Province' do
      subject.provinces.should be_a Enumerable
      subject.provinces.first.should be_a PSGC::Province
    end
  end
end
