require 'digest/sha1'

class Admin::Administrator < ActiveRecord::Base
  attr_accessible :username, :email
  attr_accessor :password
  
  validates :username, :password, :presence => true
  validates :email, :presence=>true, :length=>{:maximum=>250}, :format=>{:with => /^[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/ , :unless => Proc.new{|e| e.email.blank?} }
  validates :password_salt, :crypted_password, :presence => true, :unless => Proc.new {|a| a.password.blank?}
  validates :password_confirmation, :presence => true, :unless => Proc.new {|a| a.password.blank?}
  validates :password, :length=>{:minimum => 4, :maximum=>50}, :unless => Proc.new {|a| a.password.blank?}
  validates_confirmation_of :password, :if => Proc.new {|a| !a.password.blank? && !a.password_confirmation.blank?}
  validates_uniqueness_of :username, :email
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.crypted_password = Admin::Administrator.encrypted_password(pwd, self.password_salt)
  end
  
  def self.encrypted_password(pwd, salt)
    Digest::SHA1.hexdigest(pwd + salt)
  end
  
  def self.authenticate(username, password)
    admin = Admin::Administrator.find_by_username(username)
    if admin
      if admin.crypted_password != Admin::Administrator.encrypted_password(password, admin.password_salt)
        admin = nil
      end
    end
    admin
  end
  
  #######
  private
  #######
  
  def create_new_salt
    self.password_salt = self.object_id.to_s + rand.to_s
  end
end