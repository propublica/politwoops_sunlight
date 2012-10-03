class Party < ActiveRecord::Base
  has_many :politicians
  default_scope :order => 'display_name ASC'
end
