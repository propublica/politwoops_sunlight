class Admin::SysSetting < ActiveRecord::Base
  attr_accessible :attr_key, :attr_val
  validates_presence_of  :attr_key, :attr_val
  validates_uniqueness_of :attr_key
  
  def self.auto_publish_delay_minutes
    Admin::SysSetting.find_by_attr_key(:auto_publish_delay_minutes).try(:attr_val).to_i
  end
  
  def self.auto_publish_delay_seconds
    Admin::SysSetting.auto_publish_delay_minutes.to_i * 60
  end
end