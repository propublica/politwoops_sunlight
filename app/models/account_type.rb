# encoding: utf-8
class AccountType < ActiveRecord::Base
  has_many :politicians
end
