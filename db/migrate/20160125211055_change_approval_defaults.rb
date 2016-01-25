class ChangeApprovalDefaults < ActiveRecord::Migration
	def up
		change_table :deleted_tweets do |t|
			t.column :approved, :default => true
			t.column :reviewed, :default => true
		end
	end

	def down
		change_table :deleted_tweets do |t|
			t.column :approved, :default => nil
			t.column :reviewed, :default => nil
		end
	end
end
