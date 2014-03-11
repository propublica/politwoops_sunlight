require 'spec_helper'

describe 'Party' do

  let(:party) { Party.last }

  describe 'validations' do

    it 'should validate name existence' do
      new_party = Party.new
      new_party.valid?.should eq false
    end
  end

  describe 'properties' do

    it 'should display name as party_name' do
      FactoryGirl.create :party, name: 'frente-amplio', display_name: nil
      party.party_name.should eq 'Frente Amplio'
    end

    it 'should display display_name as party_name' do
      FactoryGirl.create :party, name: 'frente-amplio', display_name: 'Frente Amplio'
      party.party_name.should eq 'Frente Amplio'
    end
  end

  describe 'relationships' do

    let(:politician) { FactoryGirl.create :politician }

    before(:each) { politician }

    it 'should display politicians that belong to this party' do
      party.politicians.count.should eq 1
      party.politicians.first.user_name = politician.user_name
    end
  end

  describe 'tweets' do
    let(:one_party) { FactoryGirl.create :party }
    let(:another_party) { FactoryGirl.create :party }

    let(:politician1) { FactoryGirl.create :politician, party: one_party }
    let(:politician2) { FactoryGirl.create :politician, party: one_party }
    let(:politician3) { FactoryGirl.create :politician, party: another_party }

    before :each do
      5.times do
        FactoryGirl.create :tweet, politician: politician1, user_name: politician1.user_name
        FactoryGirl.create :tweet, politician: politician2, user_name: politician2.user_name
        FactoryGirl.create :tweet, politician: politician3, user_name: politician3.user_name
      end
    end

    it 'should give party tweets' do
      one_party.tweets.count.should eq 10
      another_party.tweets.count.should eq 5
    end
  end

  describe 'deleted tweets' do
    let(:one_party) { FactoryGirl.create :party }
    let(:another_party) { FactoryGirl.create :party }

    let(:politician1) { FactoryGirl.create :politician, party: one_party }
    let(:politician2) { FactoryGirl.create :politician, party: one_party }
    let(:politician3) { FactoryGirl.create :politician, party: another_party }

    before :each do
      2.times do
        FactoryGirl.create :deleted_tweet, politician: politician1, user_name: politician1.user_name
        FactoryGirl.create :deleted_tweet, politician: politician2, user_name: politician2.user_name
        FactoryGirl.create :deleted_tweet, politician: politician3, user_name: politician3.user_name, approved: true
      end

      3.times do
        FactoryGirl.create :deleted_tweet, politician: politician1, user_name: politician1.user_name, approved: true
        FactoryGirl.create :deleted_tweet, politician: politician2, user_name: politician2.user_name, approved: true
        FactoryGirl.create :deleted_tweet, politician: politician3, user_name: politician3.user_name
      end
    end

    it 'should give party deleted tweets' do
      one_party.deleted_tweets.count.should eq 10
      another_party.deleted_tweets.count.should eq 5
    end

    it 'should give party twoops tweets' do
      one_party.twoops.count.should eq 6
      another_party.twoops.count.should eq 2
    end
  end
end
