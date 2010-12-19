class Tweet < ActiveRecord::Base
  belongs_to :politician

  def details
    JSON.parse(tweet)
  end  
end
