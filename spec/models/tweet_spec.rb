require 'spec_helper'

describe 'Tweet' do

  let(:politician) { FactoryGirl.create :politician }

  before :each do
    5.times { FactoryGirl.create :tweet, politician: politician, user_name: politician.user_name }
  end

  describe 'scopes' do

    it 'should display tweets with content' do
      FactoryGirl.create :tweet, content: nil, politician: politician
      Tweet.with_content.count.should eq 5
    end

    it 'should display based on years' do
      Tweet.in_year(Time.now.year).count.should eq 5
    end
  end

  describe 'properties' do
    it 'should get tweet details' do
      details = Tweet.first.details
      details['user']['screen_name'].should eq 'diablo_urbano'
    end
  end
end
