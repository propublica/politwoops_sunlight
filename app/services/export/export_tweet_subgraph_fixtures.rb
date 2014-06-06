module Export
  class ExportTweetSubgraphFixtures < ServiceBase
    include Virtus.model
    attribute :tweet, Tweet
    attribute :export_dir, String

    def call
      deleted_tweet = DeletedTweet.where(:id => tweet.id).first
      pol = tweet.politician
      # Call accessors now to fail early
      models = [tweet, deleted_tweet, pol, pol.party, pol.office, pol.account_type].compact
      ExportFixtures.call(:models => models, :export_dir => export_dir)
    end
  end
end

