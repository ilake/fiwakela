class AddStatusBadgesColumn < ActiveRecord::Migration
  def self.up
    add_column :statuses, :badges, :integer, :default => 0
    add_index :statuses, :badges
  end

  def self.down
    remove_column :statuses, :badges
  end
end
