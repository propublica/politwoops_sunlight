require 'factory_girl'

FactoryGirl.define do
  factory :politician do
    user_name { Faker::Internet.user_name }
    twitter_id { Faker::Number.number(10) }
    state { Faker::Address.state }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    suffix 'Mr.'
    party

    trait :montevideo do
      state 'montevideo'
    end
  end

  factory :party do
    name { Faker::Company.name }
    display_name { Faker::Company.name }
  end

  factory :tweet do
    content Faker::Lorem.characters(140)
    deleted false
    created { Time.now }
    modified { Time.now }
    approved false
    reviewed false
    is_hit 0
    politician
    user_name { Faker::Internet.user_name } 
    tweet '{"contributors": null, "truncated": false, "text": "I am testing some stuff (this will be deleted) :P", "in_reply_to_status_id": null, "id": 439114275022704641, "favorite_count": 0, "source": "<a href=\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\" rel=\"nofollow\">Twitter for Mac</a>", "retweeted": false, "coordinates": null, "entities": {"symbols": [], "user_mentions": [], "hashtags": [], "urls": []}, "in_reply_to_screen_name": null, "id_str": "439114275022704641", "retweet_count": 0, "in_reply_to_user_id": null, "favorited": false, "user": {"follow_request_sent": null, "profile_use_background_image": true, "contributors_enabled": false, "id": 22808228, "verified": false, "profile_image_url_https": "https://pbs.twimg.com/profile_images/2736982163/2eb67ae3dff31f9b0a7705e11970ca71_normal.jpeg", "profile_sidebar_fill_color": "252429", "profile_text_color": "666666", "followers_count": 429, "profile_sidebar_border_color": "181A1E", "location": "Montevideo", "default_profile_image": false, "id_str": "22808228", "is_translation_enabled": false, "utc_offset": -10800, "statuses_count": 2338, "description": "I lOvE thE CHaOs\nI read, I blog, I code among other things", "friends_count": 901, "profile_link_color": "2FC2EF", "profile_image_url": "http://pbs.twimg.com/profile_images/2736982163/2eb67ae3dff31f9b0a7705e11970ca71_normal.jpeg", "notifications": null, "geo_enabled": true, "profile_background_color": "1A1B1F", "profile_background_image_url": "http://abs.twimg.com/images/themes/theme9/bg.gif", "name": "Jaime Andres D\u00e1vila", "lang": "en", "following": null, "profile_background_tile": false, "favourites_count": 7, "screen_name": "diablo_urbano", "url": "http://diablo-urban-o.com", "created_at": "Wed Mar 04 18:03:02 +0000 2009", "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme9/bg.gif", "time_zone": "Buenos Aires", "protected": false, "default_profile": false, "is_translator": false, "listed_count": 19}, "geo": null, "in_reply_to_user_id_str": null, "lang": "en", "created_at": "Thu Feb 27 19:06:16 +0000 2014", "filter_level": "medium", "in_reply_to_status_id_str": null, "place": null}'
  end

  factory :deleted_tweet do
    content Faker::Lorem.characters(140)
    deleted true
    created { Time.now }
    modified { Time.now }
    approved false
    reviewed false
    is_hit 0
    politician
    user_name { Faker::Internet.user_name } 
    tweet '{"contributors": null, "truncated": false, "text": "I am testing some stuff (this will be deleted) :P", "in_reply_to_status_id": null, "id": 439114275022704641, "favorite_count": 0, "source": "<a href=\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\" rel=\"nofollow\">Twitter for Mac</a>", "retweeted": false, "coordinates": null, "entities": {"symbols": [], "user_mentions": [], "hashtags": [], "urls": []}, "in_reply_to_screen_name": null, "id_str": "439114275022704641", "retweet_count": 0, "in_reply_to_user_id": null, "favorited": false, "user": {"follow_request_sent": null, "profile_use_background_image": true, "contributors_enabled": false, "id": 22808228, "verified": false, "profile_image_url_https": "https://pbs.twimg.com/profile_images/2736982163/2eb67ae3dff31f9b0a7705e11970ca71_normal.jpeg", "profile_sidebar_fill_color": "252429", "profile_text_color": "666666", "followers_count": 429, "profile_sidebar_border_color": "181A1E", "location": "Montevideo", "default_profile_image": false, "id_str": "22808228", "is_translation_enabled": false, "utc_offset": -10800, "statuses_count": 2338, "description": "I lOvE thE CHaOs\nI read, I blog, I code among other things", "friends_count": 901, "profile_link_color": "2FC2EF", "profile_image_url": "http://pbs.twimg.com/profile_images/2736982163/2eb67ae3dff31f9b0a7705e11970ca71_normal.jpeg", "notifications": null, "geo_enabled": true, "profile_background_color": "1A1B1F", "profile_background_image_url": "http://abs.twimg.com/images/themes/theme9/bg.gif", "name": "Jaime Andres D\u00e1vila", "lang": "en", "following": null, "profile_background_tile": false, "favourites_count": 7, "screen_name": "diablo_urbano", "url": "http://diablo-urban-o.com", "created_at": "Wed Mar 04 18:03:02 +0000 2009", "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme9/bg.gif", "time_zone": "Buenos Aires", "protected": false, "default_profile": false, "is_translator": false, "listed_count": 19}, "geo": null, "in_reply_to_user_id_str": null, "lang": "en", "created_at": "Thu Feb 27 19:06:16 +0000 2014", "filter_level": "medium", "in_reply_to_status_id_str": null, "place": null}'
  end
end
