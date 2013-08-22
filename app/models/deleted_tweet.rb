class DeletedTweet < Tweet
  set_table_name "deleted_tweets"
  belongs_to :reviewed_by, :class_name => Admin::Administrator, :foreign_key => :reviewed_by_id
  
  default_scope :order => 'created DESC'
  scope :waiting_review, :conditions => ["reviewed = 0"]
end