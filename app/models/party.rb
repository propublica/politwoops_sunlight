# encoding: utf-8
class Party < ActiveRecord::Base
  has_many :politicians

  def tweets
    Tweet.joins(:politician).where(:politicians => { :party_id => self.id })
  end

  def deleted_tweets
    DeletedTweet.joins(:politician).where(:politicians => { :party_id => self.id })
  end

  def twoops
    DeletedTweet.joins(:politician).where(:approved => true, :politicians => { :party_id => self.id })
  end
end
