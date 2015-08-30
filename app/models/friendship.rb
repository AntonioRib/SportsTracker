class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'

  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :user_id, :scope => [:friend_id]

  scope :accepted, -> { where(status: 'accepted') }
  scope :requested, -> { where(status: 'requested') }
  scope :pending, -> { where(status: 'pending') }
end
