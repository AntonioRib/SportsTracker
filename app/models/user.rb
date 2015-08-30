class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_activities, dependent: :destroy
  has_many :activities, through: :user_activities

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :user_teams
  has_many :teams, through: :user_teams

  has_many :sports, through: :activities
  has_many :places, through: :activities

  validates_presence_of :name, :birth_date

  def self.search(search)
    where("users.email like ?", "%#{search}%")
  end

end
