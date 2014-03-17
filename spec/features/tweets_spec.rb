# encoding: utf-8
require 'spec_helper'

describe 'Tweets' do
  let(:one_party) { FactoryGirl.create :party }
  let(:another_party) { FactoryGirl.create :party }

  let(:politician1) { FactoryGirl.create :politician, :montevideo, party: one_party }
  let(:politician2) { FactoryGirl.create :politician, party: one_party }
  let(:politician3) { FactoryGirl.create :politician, party: another_party }

  before :each do
    2.times do
      FactoryGirl.create :deleted_tweet, politician: politician1, user_name: politician1.user_name, approved: true
      FactoryGirl.create :deleted_tweet, politician: politician2, user_name: politician2.user_name
      FactoryGirl.create :deleted_tweet, politician: politician3, user_name: politician3.user_name, approved: true
    end

    3.times do
      FactoryGirl.create :deleted_tweet, politician: politician1, user_name: politician1.user_name, approved: true
      FactoryGirl.create :deleted_tweet, politician: politician2, user_name: politician2.user_name, approved: true
      FactoryGirl.create :deleted_tweet, politician: politician3, user_name: politician3.user_name
    end
  end

  describe 'index' do
    before(:each) { visit '/' }

    it 'should display all tweets that are marked as approved' do
      all('.section').count.should eq 10
    end

    context 'filter' do
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
        state = find(:xpath, "//form/div[@class='filter']/div[@class='dropdown open']/ul[@class='dropdown-menu']/li[1]/a").text
        State.all.include?(state).should be true
      end

      it 'should filter by state', js: true do
        find('.filter #state').click
        all(:xpath, "//form/div[@class='filter']/div[@class='dropdown open']/ul[@class='dropdown-menu']/li/a[@alt='montevideo']").first.click
        sleep(3)

        all('.section').count.should eq 5
      end
    end
  end
end
