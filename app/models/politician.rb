# encoding: utf-8
require "open-uri"
require 'sexmachine'

class Politician < ActiveRecord::Base
  CollectingAndShowing = 1
  CollectingNotShowing = 2
  NotCollectingOrShowing = 3
  NotCollectingButShowing = 4

  attr_accessible :twitter_id, :user_name, :party_id, :status, :state, :account_type_id,
                  :office_id, :first_name, :middle_name, :last_name, :suffix, :gender,
                  :bioguide_id, :opencivicdata_id

  has_attached_file :avatar, { :path => ':base_path/avatars/:filename',
                               :url => "/images/avatars/:filename",
                               :default_url => '' }

  belongs_to :party

  belongs_to :office

  belongs_to :account_type

  has_many :tweets
  has_many :deleted_tweets

  has_many :account_links
  has_many :links, :through => :account_links

  #default_scope :order => 'user_name'

  scope :active, -> { where status: [1, 4]}
  scope :collecting, -> { where status: [CollectingAndShowing, CollectingNotShowing] }
  scope :showing, -> { where status: [CollectingAndShowing, NotCollectingButShowing] }

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
    status                 'status'
    collecting?            'collecting'
    showing?               'showing'
    bioguide_id            'bioguide_id'
    opencivicdata_id       'opencivicdata_id'
  end

  def collecting?
    [CollectingAndShowing, CollectingNotShowing].include?(status)
  end

  def showing?
    [CollectingAndShowing, NotCollectingButShowing].include?(status)
  end

  def self.guess_gender(name)
    # Each SexMachine::Detector instance loads it's own copy of the data file.
    # Let's avoid going memory crazy.
    @_sexmachine__detector ||= SexMachine::Detector.new
    @_sexmachine__detector.get_gender(name)
  end

  def guess_gender!
    gender_value = Politician.guess_gender(first_name)
    gender_map = { :male => 'M', :female => 'F' }
    gender_value = gender_map[gender_value]
    if gender_value
      self.gender = gender_value
      save!
    end
  end

  def male?
    gender == 'M'
  end

  def female?
    gender == 'F'
  end

  def ungendered?
    !(male? || female?)
  end

  def self.ungendered
    where(:gender => 'U')
  end

  def full_name
    return [office && office.abbreviation, first_name, last_name, suffix].join(' ').strip
  end

  def add_related_politicians(other_names)
    other_names.each do |other_name|
      if not other_name.empty? && other_name != self.user_name
        other_pol = Politician.find_by_user_name(other_name)
        self.links << other_pol
        self.save!
      end
    end
  end

  def remove_related_politicians(other_names)
    other_names.each do |other_name|
      if not other_name.empty? && other_name != self.user_name
        other_pol = Politician.find_by_user_name(other_name)
        AccountLink.where(:politician_id => self.id,
                          :link_id => other_pol.id).destroy_all
        AccountLink.where(:link_id => self.id,
                          :politician_id => other_pol.id).destroy_all
      end
    end
  end

  def get_related_politicians
    links = AccountLink.where("politician_id = ? or link_id = ?", self.id, self.id)

    politician_ids = links.flat_map{ |l| [l.politician_id, l.link_id] }
                          .reject{ |pol_id| pol_id == self.id }
    Politician.where(:id => politician_ids)
  end

  def twoops
    deleted_tweets.where(:approved => true)
  end

  def reset_avatar(options = {})
    begin
      twitter_user = $twitter.user(user_name)
      image_url = twitter_user.profile_image_url(:bigger)

      force_reset = options.fetch(:force, false)

      if profile_image_url.nil? || (image_url != profile_image_url) || (profile_image_url != avatar.url) || force_reset
        uri = URI::parse(image_url)
        extension = File.extname(uri.path)

        uri.open do |remote_file|
          Tempfile.open(["#{self.twitter_id}_", extension]) do |tmpfile|
            tmpfile.puts remote_file.read().force_encoding('UTF-8')
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
