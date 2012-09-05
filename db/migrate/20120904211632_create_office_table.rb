class CreateOfficeTable < ActiveRecord::Migration
  def self.up
    create_table :office_held do |t|
        t.string :title, :null => false
        t.string :abbreviation, :null => false
    end
  end

  def self.down
    drop_table :office_held
  end
end
