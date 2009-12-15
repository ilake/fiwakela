class AddStatusScoreTotal < ActiveRecord::Migration
  def self.up
    add_column :statuses, :total_score, :integer, :default => 0
  end

  def self.down
    remove_column :statuses, :total_score
  end
end
