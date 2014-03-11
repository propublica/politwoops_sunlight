namespace :db do
  desc 'Fixes the primary key schema for MySQL deployments'
  task :fix_mysql_schema => :environment do
    if "mysql2" != ActiveRecord::Base.connection.adapter_name.downcase
      puts "You aren't using the mysql2 adapter. You probably don't need to run this command."
      next
    end

    pkey = Tweet.columns.select(&:primary).first
    if pkey.nil?
      puts "The Tweet model is missing a primary key. Someting is very wrong."
      next
    end

    if 8 == pkey.limit
      puts "The primary key is already wide enough. Skipping."
      next
    end

    class WidenTweetPrimaryKey < ActiveRecord::Migration
      def self.up
        change_column :tweets, :id, :integer, :limit => 8
        change_column :deleted_tweets, :id, :integer, :limit => 8
      end
    end

    WidenTweetPrimaryKey.migrate(:up)
  end
end

Rake::Task['db:schema:load'].enhance do
  ::Rake::Task['db:fix_mysql_schema'].invoke
end

