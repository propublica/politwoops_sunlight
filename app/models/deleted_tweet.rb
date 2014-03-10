# encoding: utf-8
class DeletedTweet < Tweet
  self.table_name = "deleted_tweets"
end
