class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :fb_id
      t.datetime :target_time
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
