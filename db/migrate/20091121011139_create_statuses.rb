class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.belongs_to :user
      t.integer :state, :continuous_num, :num, :score, :default => 0
      t.datetime :average, :default => 0
      t.float :success_rate, :default => 0
    end
  end

  def self.down
    drop_table :statuses
  end
end
