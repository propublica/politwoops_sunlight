class Tweet < ActiveRecord::Base
  belongs_to :politician

  default_scope :order => 'modified DESC'
  
  scope :deleted, :conditions => {:deleted => 1}
  
  cattr_reader :per_page
  @@per_page = 10
  
  def details
    JSON.parse(tweet)
  end  
end
