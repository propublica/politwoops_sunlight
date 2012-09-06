class AccountLink < ActiveRecord::Base
  attr_accessible :link_id, :politician_id

  belongs_to :link, :class_name => "Politician"

end
