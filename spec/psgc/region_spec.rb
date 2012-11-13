require 'spec_helper'

RSpec::Matchers.define :be_a_province_or_district do
  match do |target|
    target.is_a?(PSGC::Province) or target.is_a?(PSGC::District)
  end
end

describe PSGC::Region do

  describe '.REGION_DATA' do
    it 'is a file' do
      File.exists?(PSGC::Region::REGION_DATA).should be_true
    end
  end

  describe '.all' do
    subject { PSGC::Region.all }
    it { should be_an_enumerable_of PSGC::Region }
  end

  subject { PSGC::Region[13] }

  it { should respond_to :id }
  it { should respond_to :code }
  it { should respond_to :name }
  it { should respond_to :provinces }
  it { should have_at_least(1).provinces }

  describe '#provinces' do
    it 'is a collection of PSGC::Province or PSGC::District' do
      subject.provinces.should be_a Enumerable
      subject.provinces.first.should be_a_province_or_district
    end
  end
end
