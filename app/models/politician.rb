class Politician < ActiveRecord::Base
  belongs_to :party

  belongs_to :office
    
  belongs_to :account_type

  has_many :tweets
  has_many :deleted_tweets
 
  has_many :account_links
  has_many :links, :through => :account_links 
   
  #default_scope :order => 'user_name'

  scope :active, :conditions => ["status = 1 OR status = 4"]
  
  validates_uniqueness_of :user_name

  def add_related_politician(related)
    if related != nil then
      unless AccountLink.where(:politician_id => related, :link_id => self).length > 0
        al = AccountLink.where(:politician_id => self, :link_id => related).first_or_create()
        al.save()
      end
    end

  end
  
  def get_related_politicians()
    pol_list = []
    pols = AccountLink.where("politician_id = ? or link_id = ?", self.id, self.id )
    pols.each do |p|
      if p.link_id != self.id and  not pol_list.include?(p.link_id) then
        pol_list.push(p.link_id)
      elsif p.politician_id != self.id and not pol_list.include?(p.politician_id) then
        pol_list.push(p.politician_id)
      end
    end
    return pol_list
  end
end
