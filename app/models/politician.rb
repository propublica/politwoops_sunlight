class Politician < ActiveRecord::Base
  belongs_to :party

  has_many :tweets
  
  has_and_belongs_to_many :groups
  
  default_scope :order => 'user_name'
end
