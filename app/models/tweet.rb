class Tweet < ActiveRecord::Base
  belongs_to :politician

  default_scope :order => 'modified DESC'
  
  scope :deleted, :conditions => {:deleted => 1}
  
  def details
    JSON.parse(tweet)
  end  
end
