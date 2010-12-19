class Politician < ActiveRecord::Base
  has_many :tweets
  
  default_scope :order => 'user_name'
end
