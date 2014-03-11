# encoding: utf-8
class Party < ActiveRecord::Base
  has_many :politicians
  
  validates :name, presence: true

  def tweets
    Tweet.for_party(self.id)
  end

  def deleted_tweets
    DeletedTweet.for_party(self.id)
  end

  def twoops
    DeletedTweet.twoops.for_party(self.id)
  end

  def party_name
    (self.display_name || self.name).titleize.gsub('-', ' ')
  end
end
