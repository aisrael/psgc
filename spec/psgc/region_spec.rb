require 'spec_helper'

describe PSGC::Region do
  it 'has an :id' do
    should respond_to :id
  end
  it 'has a :name' do
    should respond_to :name
  end
  it 'have at least one provinces' do
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
