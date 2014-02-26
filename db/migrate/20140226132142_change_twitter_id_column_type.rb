class ChangeTwitterIdColumnType < ActiveRecord::Migration
  def up
    [:tweets, :deleted_tweets].each do |table|
      change_column table, :id, "BIGINT UNSIGNED"
    end
  end

  def down
    [:tweets, :deleted_tweets].each do |table|
      change_column table, :id, :integer
    end
  end
end
