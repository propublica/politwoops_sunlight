class Party < ActiveRecord::Base
	include ActiveModel::Validations
	
	has_many :politicians
	default_scope :order => 'name ASC'
	validates_presence_of :name
end
