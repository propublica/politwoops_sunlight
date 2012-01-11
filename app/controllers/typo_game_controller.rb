class TypoGameController < ApplicationController
  def index
    @tweet = DeletedTweet.typo_unchecked.random()
  end
  
  def update
    @tweet = DeletedTweet.find(params[:id])
    p params[:deleted_tweet]
    if @tweet.update_attributes(params[:deleted_tweet])
      redirect_to "/game/typos"
    end
  end
end
