require 'spec_helper'

describe 'DeletedTweet' do

  let(:politician) { FactoryGirl.create :politician }

  before :each do
    5.times { FactoryGirl.create :deleted_tweet, politician: politician, user_name: politician.user_name }
  end

  describe 'scopes' do

    it 'should display deleted tweets' do
      DeletedTweet.deleted.count.should eq 5
    end

    it 'display twoops' do
      DeletedTweet.limit(3).each do |tweet|
        tweet.update_attributes(approved: true)
      end

      DeletedTweet.twoops.count.should eq 3
    end

    it 'should allow to pipe with Tweet scopes' do
      DeletedTweet.deleted.for_party(politician.party_id).count.should eq 5
    end
  end
end
