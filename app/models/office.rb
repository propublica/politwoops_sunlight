class Office < ActiveRecord::Base
	include ActiveModel::Validations
	
	has_many :politicians
	default_scope :order => 'title ASC'
	validates_presence_of :title
end
