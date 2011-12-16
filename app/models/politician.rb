class Politician < ActiveRecord::Base
  belongs_to :party

  has_many :tweets
  
  has_many :deleted_tweets
  
  has_and_belongs_to_many :groups
  
  default_scope :order => 'user_name'

  scope :active, :conditions => "status = 1"
  
  validates_uniqueness_of :user_name
end
