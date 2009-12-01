# == Schema Information
# Schema version: 20091129152625
#
# Table name: users
#
#  id          :integer         not null, primary key
#  fb_id       :string(255)
#  target_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  timezone    :string(255)     default("Taipei")
#  name        :string(255)
#  image       :string(255)
#

class User < ActiveRecord::Base
  has_many :records
  has_one :status

  validates_presence_of :name, :fb_id

  after_create :create_default_user_setting

  named_scope :unactived, :include => :status, :conditions => ["statuses.state <> ? AND statuses.state <> ? AND statuses.state <> ?", 1, 2, 4]

#  status = Status.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :status)
#
#  delegate *status
  

  def create_default_user_setting
    self.create_status
  end
end
