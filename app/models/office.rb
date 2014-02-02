# encoding: utf-8
class Office < ActiveRecord::Base
  has_many :politicians
  default_scope :order => 'title ASC'
end
