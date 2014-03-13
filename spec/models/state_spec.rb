
require 'spec_helper'

describe 'State' do

  let(:politician) { Politician.last }

  before :each do
    5.times { FactoryGirl.create :politician, state: 'foostate' }
    FactoryGirl.create :politician, :montevideo
    FactoryGirl.create :politician, :montevideo
  end

  it 'should return all possible states' do
    State.all.count.should eq 2
  end
end
