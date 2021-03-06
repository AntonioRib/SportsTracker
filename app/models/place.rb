class Place < ActiveRecord::Base
  has_many :activities
  has_many :user_activities, through: :activities

  has_many :sports, through: :activities

  validates :name, presence: true, uniqueness: true
end
