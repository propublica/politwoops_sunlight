# encoding: utf-8
class AccountLink < ActiveRecord::Base

  belongs_to :link, :class_name => "Politician"

end
