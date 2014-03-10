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
    before :each do
      FactoryGirl.create :politician
    end

    it 'should display politicians that belong to this party' do
      party.politicians.count.should eq 1
      party.politicians.first.user_name = Politician.last.user_name
    end
  end
end
