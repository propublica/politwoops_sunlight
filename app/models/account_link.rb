class AccountLink < AcitveRecord::Base
  validates_uniqueness_of :politician_id, :scope => [:linked_id]
end
