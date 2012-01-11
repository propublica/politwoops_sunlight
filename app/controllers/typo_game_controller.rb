class TypoGameController < ApplicationController
  def index
    @tweet = DeletedTweet.typo_unchecked.random()
    @latest_tweets = Tweet.with_content.where(:deleted => 0, :politician_id => @tweet.politician_id).where("created > ?", @tweet.modified).reorder(:created).limit(5).all
  end
  
  def update
    @tweet = DeletedTweet.find(params[:id])
    p params[:deleted_tweet]
    if @tweet.update_attributes(params[:deleted_tweet])
      redirect_to "/game/typos"
    end
  end
end
