class AddStatusLastRecordAt < ActiveRecord::Migration
  def self.up
    add_column :statuses, :last_record_at, :datetime
  end

  def self.down
    remove_column :statuses, :last_record_at
  end
end
