class Admin::TweetsController < Admin::AdminController
  before_filter :load_tweet, :only => [:review, :message]

  # list either unreviewed
  def index
    if params[:politician_id] and !params[:politician_id].blank?
      @politicians = Politician.find(params[:politician_id])
    else
      @politicians = Politician.active.all
    end

    @all_politicians = Politician.active.all

    @tweets = DeletedTweet.where(:politician_id => @politicians)

    # filter to relevant subset of deleted tweets
    @tweets = @tweets.where :reviewed => params[:reviewed], :approved => params[:approved]

    # show unreviewed tweets oldest to newest
    if !params[:reviewed]
      @tweets = @tweets.reorder "modified DESC"
    end

    per_page = params[:per_page] ? params[:per_page].to_i : nil
    per_page ||= Tweet.per_page
    per_page = 200 if per_page > 200

    @tweets = @tweets.includes(:politician => [:party]).paginate(:page => params[:page], :per_page => per_page)
    @admin = true

    respond_to do |format|
      format.html # admin/tweets/index.html.erb
      format.rss do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
    end
  end

  def reject
    ids = params[:ids]
    ids_list = ids.split(',')
    
    for id in ids_list
      @tweet = Tweet.find(id)
      @deleted_tweet = DeletedTweet.find(id)
      @deleted_tweet.reviewed = true
      @tweet.approved = false
      @tweet.reviewed = true
      @tweet.reviewed_at = Time.now
      if @tweet.save! and @deleted_tweet.save!

      else
        flash[:review_message] = t "note_is_missing",:scope => [:politwoops,:admin]
      end
    end

    redirect_to '/admin/review'
  end

  # approve or unapprove a tweet, mark it as reviewed either way
  def review
    
    review_message = (params[:review_message] || "").strip

    if [t(:approve, :scope => [:politwoops,:admin]), t(:unapprove, :scope => [:politwoops,:admin])].include?(params[:commit])
      approved = (params[:commit] == t(:approve, :scope => [:politwoops,:admin]))

      puts '--------------------'
      puts @tweet.reviewed
      puts approved
      puts review_message
      puts '======================'

      if approved and review_message.blank?
        flash[:review_message] = t "note_is_missing",:scope => [:politwoops,:admin]
        #t "You need to add a note about why you're approving this tweet."
        redirect_to params[:return_to]
        return false
      end

      @tweet.approved = approved
      @tweet.reviewed = true
      @tweet.reviewed_at = Time.now
    end

    if review_message.any?
      @tweet.review_message = review_message
    end

    @tweet.save!
    expire_action :controller => '/tweets', :action => :index

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