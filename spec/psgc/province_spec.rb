require 'spec_helper'

describe PSGC::Province do

  subject { PSGC::Region[1].provinces.first }

  it { should respond_to :id }
  it { should respond_to :code }
  it { should respond_to :name }
  it { subject.is_province?.should be_true }

  it { should respond_to :cities }
  it { should have_at_least(1).cities }

end
