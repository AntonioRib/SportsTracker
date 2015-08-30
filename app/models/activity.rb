class Activity < ActiveRecord::Base
  has_many :user_activities, dependent: :destroy
  has_many :users, through: :user_activities
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'

  has_many :team_activities, dependent: :destroy
  has_many :teams, through: :team_activities

  belongs_to :sport
  belongs_to :place

  validates_presence_of :name, :place_id, :sport_id, :owner_id

  def self.search(search)
    where('activities.name like ?', "%#{search}%")
  end

end
