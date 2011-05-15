class TwitterList 
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming  
  
  attr_accessor :user_name, :list
  
  validates_presence_of :user_name
  validates_presence_of :list
    
  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end
  
  def persisted?  
    false  
  end
end