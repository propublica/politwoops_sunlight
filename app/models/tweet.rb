class Tweet < ActiveRecord::Base
  belongs_to :politician
  has_many :tweet_images, :foreign_key => "tweet_id"

  default_scope :order => 'modified DESC'
  
  # scope :latest, :order => 'created DESC'
  scope :deleted, :conditions => "deleted = 1 AND content IS NOT NULL"
  scope :with_content, :conditions => "content IS NOT NULL"
  
  cattr_reader :per_page
  @@per_page = 10
  
  def self.random
    reorder("RAND()").find(:first, :limit => 1)
  end
    
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