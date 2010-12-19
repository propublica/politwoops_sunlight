class Tweet < ActiveRecord::Base
  belongs_to :politician

  default_scope :order => 'modified DESC'
  
  def details
    JSON.parse(tweet)
  end  
end
