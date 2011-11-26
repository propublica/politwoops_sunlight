class Tweet < ActiveRecord::Base
  belongs_to :politician

  default_scope :order => 'modified DESC'
  
  scope :deleted, :conditions => "deleted = 1 AND content IS NOT NULL"

  scope :published_in, lambda { |year, month| where("YEAR(created) = ? AND MONTH(created) = ?", year, month) }

  scope :modified_in, lambda { |year, month| where("YEAR(modified) = ? AND MONTH(modified) = ?", year, month) }

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
