# encoding: utf-8
require "open-uri"

class Politician < ActiveRecord::Base
  CollectingAndShowing = 1
  CollectingNotShowing = 2
  NotCollectingOrShowing = 3
  NotCollectingButShowing = 4

  has_attached_file :avatar, { :path => ':base_path/avatars/:filename',
                               :url => "/images/avatars/:filename",
                               :default_url => 'images/avatar_missing_404.png' }

  belongs_to :party

  belongs_to :office
    
  belongs_to :account_type

  has_many :tweets
  has_many :deleted_tweets
 
  has_many :account_links
  has_many :links, :through => :account_links 
   
  #default_scope :order => 'user_name'

  scope :active, :conditions => ["status = 1 OR status = 4"]
  scope :collecting, :conditions => { :status => [CollectingAndShowing, CollectingNotShowing] }
  scope :showing, :conditions => { :status => [NotCollectingOrShowing, NotCollectingButShowing] }
  
  validates_uniqueness_of :user_name, :case_sensitive => false

  comma do
    user_name              'user_name'
    twitter_id             'twitter_id'
    party :display_name => 'party_name'
    state                  'state'
    office :title       => 'office_title'
    account_type :name  => 'account_type'
    first_name             'first_name'
    middle_name            'middle_name'
    last_name              'last_name'
    suffix                 'suffix'
  end

  def full_name
    return [office && office.abbreviation, first_name, last_name, suffix].join(' ').strip
  end

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

  def twoops
    deleted_tweets.where(:approved => true)
  end

  def reset_avatar (options = {})
    begin
      twitter_user = Twitter.user(user_name)
      image_url = twitter_user.profile_image_url(:bigger)

      force_reset = options.fetch(:force, false)

      if profile_image_url.nil? || (image_url != profile_image_url) || force_reset
        uri = URI::parse(image_url)
        extension = File.extname(uri.path)

        uri.open do |remote_file|
          Tempfile.open(["#{self.twitter_id}_", extension]) do |tmpfile|

            tmpfile.puts remote_file.read()
            self.avatar = tmpfile
            self.profile_image_url = image_url
            self.save!
          end
        end
      end
      return [true, nil]
    rescue Twitter::Error::Forbidden => e
      return [false, e.to_s]
    rescue Twitter::Error::NotFound
      return [false, "No such user name: #{user_name}"]
    end
  end
end
