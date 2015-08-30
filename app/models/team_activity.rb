class TeamActivity < ActiveRecord::Base
  belongs_to :team
  belongs_to :activity

  validates_presence_of :team_id, :activity_id, presence: true
end
