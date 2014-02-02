class Admin::ReportsController < Admin::AdminController
  layout "admin"

  before_filter :admin_only

  def annual
    earliest_tweet_timestamp = DeletedTweet.minimum(:created)
    if earliest_tweet_timestamp.nil?
      return not_found
    end
    @year = (params[:year] && params[:year].to_i) || Date.today.year
    if earliest_tweet_timestamp.year > @year
      return not_found
    end

    @tweet_tally = Tweet.joins(:politician).in_year(@year).count
    @delete_tally = DeletedTweet.joins(:politician).in_year(@year).count
    @approval_tally = DeletedTweet.joins(:politician).in_year(@year).where(:approved => true).count
    @approval_pct = (@delete_tally.zero? && 0) || (@approval_tally * 100 / @delete_tally)
    @observed_account_tally = Tweet.joins(:politician).in_year(@year).group(:politician_id).order(nil).count.length

    @tweets_per_account = Tweet.joins(:politician).in_year(@year).group(:politician_id).count
    @deletes_per_account = DeletedTweet.joins(:politician).in_year(@year).group(:politician_id).count
    @twoops_per_account = DeletedTweet.joins(:politician).in_year(@year).where(:approved => true).group(:politician_id).count
    @tweeting_account_tally = @tweets_per_account.length
    @deleting_account_tally = @deletes_per_account.length
    @deleting_account_pct = (@observed_account_tally.zero? && 0) || (@deleting_account_tally * 100 / @observed_account_tally)
    @twooping_account_tally = @twoops_per_account.length

    @top_tweeters = @tweets_per_account.sort_by(&:second).last(5).reverse.map{ |pol_id, cnt| [Politician.find(pol_id), cnt] }
    @top_deleters = @deletes_per_account.sort_by(&:second).last(5).reverse.map{ |pol_id, cnt| [Politician.find(pol_id), cnt] }
    @top_twoopers = @twoops_per_account.sort_by(&:second).last(5).reverse.map{ |pol_id, cnt| [Politician.find(pol_id), cnt] }

    @top_twoops_rates = @deletes_per_account.select{ |pol_id, deletes| deletes > 5 }.map{ |pol_id, deletes| [pol_id, deletes.to_f * 100 / @tweets_per_account[pol_id].to_f] }.sort_by(&:second).last(10)
    @top_twoops_rates = @twoops_per_account.select{ |pol_id, deletes| deletes > 5 }.map{ |pol_id, twoops| [pol_id, twoops.to_f * 100 / @tweets_per_account[pol_id].to_f] }.sort_by(&:second).last(10)
    @top_twoopsters = @top_twoops_rates.reverse.map{ |pol_id, pct| [Politician.find(pol_id), pct.round] }

    @tweets_per_party = Tweet.joins(:politician).in_year(@year).group(:party_id).count
    @deletes_per_party = DeletedTweet.joins(:politician).in_year(@year).group(:party_id).count
    @twoops_per_party = DeletedTweet.joins(:politician).in_year(@year).where(:approved => true).group(:party_id).count
    @parties = Party.find(@tweets_per_party.keys)

    @tweeting_accounts_per_party = Tweet.joins(:politician).in_year(@year).group(:party_id).count(:politician_id, :distinct => true)
    @deleting_accounts_per_party = DeletedTweet.joins(:politician).in_year(@year).group(:party_id).count(:politician_id, :distinct => true)
    @twooping_accounts_per_party = DeletedTweet.joins(:politician).in_year(@year).where(:approved => true).group(:party_id).count(:politician_id, :distinct => true)
  end

end
