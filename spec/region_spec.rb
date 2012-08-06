require 'spec_helper'

describe PSGC::Region do
  it 'has an :id' do
    should respond_to :id
  end
  it 'has a :name' do
    should respond_to :name
  end
end
