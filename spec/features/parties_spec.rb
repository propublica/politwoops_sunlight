# encoding: utf-8
require 'spec_helper'

describe 'Parties' do
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

  it 'should show tweets associated to a party' do
    visit "/party/#{one_party.name}"

    expect(page).to have_content 'Últimos mensajes borrados'
    first('.tweet-content .tweetTitle .fullname').should have_content(politician1.party.name.upcase)
  end

  it 'should show pager options' do
    visit "/party/#{one_party.name}"

    find('.results-per-page').should have_content('Resultados por página: 10 20 50')
  end
end
