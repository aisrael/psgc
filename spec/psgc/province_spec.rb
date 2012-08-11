require 'spec_helper'

describe PSGC::Province do

  it { should respond_to :id }
  it { should respond_to :code }
  it { should respond_to :name }
  it { subject.is_province?.should be_true }

end
