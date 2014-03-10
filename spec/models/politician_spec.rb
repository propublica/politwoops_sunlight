require 'spec_helper'

describe 'Politician' do

  let(:politician) do
    Politician.last
  end

  describe 'validations' do

    it 'should allow unique usernames' do
      new_politician = Politician.new(user_name: Politician.first.user_name)
      new_politician.valid?.should eq false
    end
  end

  describe 'full name' do
    it 'should return full name with everything' do
      FactoryGirl.create(:politician)

      full_name = "#{politician.suffix} #{politician.first_name} #{politician.middle_name} #{politician.last_name}"
      Politician.last.full_name.should eq full_name
    end

    it 'should include correctly existing fields' do
      FactoryGirl.create(:politician, middle_name: nil)

      full_name = "#{politician.suffix} #{politician.first_name} #{politician.last_name}"
      Politician.last.full_name.should eq full_name
    end

    it 'should include correctly without sufix' do
      FactoryGirl.create(:politician, suffix: nil, middle_name: nil)

      full_name = "#{politician.first_name} #{politician.last_name}"
      Politician.last.full_name.should eq full_name
    end
  end

  describe 'TwitterClient' do
    
    it 'should reset avatar' do
      FactoryGirl.create(:politician, user_name: 'diablo_urbano', twitter_id: 22808228)

      politician.avatar.url.should eq '/assets/avatar_missing_male.png'

      VCR.use_cassette('twitter_user_info') do
        politician.reset_avatar
        politician.avatar.url.should_not eq '/assets/avatar_missing_male.png'
      end
    end
  end
end
