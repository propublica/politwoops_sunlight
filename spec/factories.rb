require 'factory_girl'

FactoryGirl.define do
  factory :politician do
    user_name { Faker::Internet.user_name }
    twitter_id { Faker::Number.number(10) }
    state 'Montevideo'
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    suffix 'Mr.'
    party
  end

  factory :party do
    name { Faker::Company.name }
    display_name { Faker::Company.name }
  end
end
