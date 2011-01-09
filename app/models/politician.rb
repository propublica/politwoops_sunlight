class Politician < ActiveRecord::Base
  belongs_to :party

  has_many :tweets
  
  default_scope :order => 'user_name'
end
