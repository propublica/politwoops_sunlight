# encoding: utf-8
class DeletedTweet < Tweet
  self.table_name = "deleted_tweets"

  scope :deleted, conditions: "deleted = 1 AND content IS NOT NULL"
  scope :twoops , conditions: "approved = 1"
  scope :hits, conditions: "is_hit = 1 AND approved = 1"
end
