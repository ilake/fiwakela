class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.datetime :time
      t.datetime :target_time
      t.text :content
      t.integer :user_id
      t.boolean :success, :default => true
      t.boolean :pri, :default => false
      t.boolean :status, :default => true

      t.timestamps
    end

    add_index :records, :user_id
  end

  def self.down
    drop_table :records
  end
end
