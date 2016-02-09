class ChangeApprovalDefaults < ActiveRecord::Migration
    def self.up
        change_column_default :tweets, :approved, true
        change_column_default :deleted_tweets, :approved, true
        change_column_default :tweets, :reviewed, true
        change_column_default :deleted_tweets, :reviewed, true
    end

    def self.down
        change_column_default :tweets, :approved, false
        change_column_default :deleted_tweets, :approved, false
        change_column_default :tweets, :reviewed, false
        change_column_default :deleted_tweets, :reviewed, false
    end
end
