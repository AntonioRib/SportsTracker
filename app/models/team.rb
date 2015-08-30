class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, through: :user_teams

  has_many :team_activities
  has_many :activities, through: :team_activities

  validates_presence_of :name
end
