# encoding: utf-8
class Party < ActiveRecord::Base
  has_many :politicians
  before_save :prepare_name

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

  def self.by_name(name)
    where(name: name).first
  end

  def self.active_politicians_of(name)
    by_name(name).politicians.active
  end

  private

  def prepare_name
    self.display_name = self.display_name || self.name
    self.name = self.name.parameterize
  end
end
