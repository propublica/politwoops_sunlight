# encoding: utf-8
require 'spec_helper'

describe 'Politicians' do
  let(:one_party) { FactoryGirl.create :party }
  let(:another_party) { FactoryGirl.create :party }

  let(:politician1) { FactoryGirl.create :politician, :montevideo, party: one_party }
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

  describe 'all' do
    before(:each) { visit '/users' }

    it 'should display party dropdown options', js: true do
      expect(page).to have_content 'Partido'

      find('.filter #party').click
      Party.all.map(&:party_name).include?(
        find(:xpath, "//form/div[@class='filter']/div[@class='dropdown open']/ul[@class='dropdown-menu']/li[1]/a").text
      ).should be true
    end

    it 'should display state dropdown options', js: true do
      expect(page).to have_content 'Departamento'

      find('.filter #state').click
      State.all.include?(
        find(:xpath, "//form/div[@class='filter']/div[@class='dropdown open']/ul[@class='dropdown-menu']/li[1]/a").text
      ).should be true
    end

    it 'should display list of politicians' do
      all('.section').count.should eq 3
    end

    it 'should contain name of first politician' do
      Politician.all.map(&:full_name).include?(first('.section .content a').text).should be true
    end

    it 'should show pager options' do
      find('.results-per-page').should have_content('Resultados por página: 10 20 50')
    end
  end

  describe 'filter' do
    before(:each) { visit '/users' }

    it 'should filter by party', js: true do
      find('.filter #state').click
      all(:xpath, "//form/div[@class='filter']/div[@class='dropdown open']/ul[@class='dropdown-menu']/li/a[@alt='montevideo']").first.click

      find('.section').text.should have_content('MONTEVIDEO')
      true.should eq true
    end
  end

  describe 'show' do
    before(:each) { visit "/user/#{politician1.user_name}" }
    
    it 'should display user data' do
      find('#info').text.should have_content "(#{politician1.party.party_name.upcase})"
      all('.section').count.should eq 3
    end

    it 'should show pager options' do
      find('.results-per-page').should have_content('Resultados por página: 10 20 50')
    end

    it 'should display user tweets' do
      first('.section .content').should have_content DeletedTweet.where(politician_id: politician1.id).last.details['user']['name']
    end
  end
end
