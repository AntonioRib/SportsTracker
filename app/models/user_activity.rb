class UserActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  validates_presence_of :user_id, :activity_id
  validates_uniqueness_of :user_id, :scope => [:activity_id]
end
