class AddReviewedByToTweetsTable < ActiveRecord::Migration
  def change
    add_column :deleted_tweets, :reviewed_by_id, :integer
  end
end
