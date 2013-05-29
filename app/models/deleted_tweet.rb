class DeletedTweet < Tweet
  set_table_name "deleted_tweets"

  default_scope :order => 'created DESC'
end