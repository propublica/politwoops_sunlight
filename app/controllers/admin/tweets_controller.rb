class Admin::TweetsController < Admin::AdminController
  before_filter :load_tweet, :only => :review

  # list either unreviewed
  def index
    # boilerplate I don't fully understand
    @group_name = params[:group_name] || @default_group.name
    @politicians = Politician.active.joins(:groups).where({:groups => {:name => @group_name}}).all

    @tweets = DeletedTweet.where(:politician_id => @politicians)

    # filter to relevant subset of deleted tweets
    @tweets = @tweets.where :reviewed => params[:reviewed], :approved => params[:approved]

    per_page = params[:per_page] ? params[:per_page].to_i : nil
    per_page ||= Tweet.per_page
    per_page = 200 if per_page > 200

    @tweets = @tweets.includes(:politician => [:party]).paginate(:page => params[:page], :per_page => per_page)
  end

  # approve or unapprove a tweet, mark it as reviewed either way
  def review
    approved = (params[:commit] == "Approve")

    review_message = (params[:review_message] || "").strip

    if !@tweet.reviewed? and approved and review_message.blank?
      flash[:review_message] = "You need to add a note about why you're approving this tweet."
      redirect_to params[:return_to]
      return false
    end

    @tweet.approved = approved
    @tweet.reviewed = true
    @tweet.reviewed_at = Time.now

    if review_message.any?
      @tweet.review_message = review_message
    end

    @tweet.save!

    # expire_action :controller => '/tweets', :action => :index

    redirect_to params[:return_to]
  end


  # filters

  def load_tweet
    unless params[:id] and (@tweet = DeletedTweet.find(params[:id]))
      render :nothing => true, :status => :not_found
      return false
    end
  end

end