class Politician < ActiveRecord::Base
  belongs_to :party

  belongs_to :office_held
    
  belongs_to :account_type

  has_many :tweets
  
  has_many :deleted_tweets

  has_and_belongs_to_many :groups
  
  default_scope :order => 'user_name'

  scope :active, :conditions => "status = 1"
  
  validates_uniqueness_of :user_name
end
