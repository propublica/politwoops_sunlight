class DeletedTweet < ActiveRecord::Base
  belongs_to :politician

  default_scope :order => 'modified DESC'
  
  cattr_reader :per_page
  @@per_page = 10
  
  def details
    JSON.parse(tweet)
  end  

  def format
    {
      :created_at => created,
      :updated_at => modified,
      :id => id.to_s,
      :politician_id => politician_id,
      :details => details,
      :content => content,
      :user_name => user_name
    }
  end
end
