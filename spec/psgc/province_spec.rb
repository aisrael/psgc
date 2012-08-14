require 'spec_helper'

describe PSGC::Province do

  subject { PSGC::Region[1].provinces.first }

  it { should respond_to :id }
  it { should respond_to :code }
  it { should respond_to :name }
  it { subject.should be_a_province }

  describe '#cities' do
    specify { subject.cities.should be_an_enumerable_of PSGC::City }
  end
  describe '#municipalities' do
    specify { subject.municipalities.should be_an_enumerable_of PSGC::Municipality }
  end
end
