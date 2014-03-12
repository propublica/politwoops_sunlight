require 'spec_helper'

describe PartiesController do
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

  describe 'show' do

    it 'should return tweets associated to an specific party' do
      get :show, {name: one_party.name}
      response.should render_template('tweets/index')
    end
  end
end
