class DashboardController < ApplicationController

  def index
    if user_signed_in?
      @userActivities = current_user.activities
      @trueFriends = current_user.friends.joins(:friendships).where("friendships.status = 'accepted'")
      @nextActivity = current_user.activities.joins(:place).where('date > ?', DateTime.now).
          select('activities.*, places.name AS location').order(:date).first
      @newestFriend = @trueFriends.order('friendships.added_on DESC').first
      @lastVisit = current_user.places.joins(:activities).where('activities.date < ?', DateTime.now).
          select('places.name AS location, activities.date AS last_date').order('last_date DESC').first
      @mostPopularSport = @trueFriends.joins(:sports).group('sports.id').order('count(activities.id) DESC').select('sports.name').first
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def profile
    if user_signed_in?
      @user = current_user
      @nActivities = @user.activities.count
      @nFriends = current_user.friendships.accepted.joins('INNER JOIN users ON users.id = friend_id').count
      @nTeams = current_user.teams.count
      list_user_activities
      list_user_friends
      list_user_teams
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def list_user_activities
    if user_signed_in?

      @current = current_user
      if !params[:selected_sport].blank?
        @activities = current_user.activities.where('activities.sport_id = ?', params[:selected_sport]).joins(:user_activities, :sport, :place).
            select('activities.*, user_activities.duration AS duration, sports.name AS sport_name, places.name AS place_name').order(:date).distinct
      else
        @activities = current_user.activities.joins(:user_activities, :sport, :place).select('activities.*,
            user_activities.duration AS duration, sports.name AS sport_name, places.name AS place_name').order(:date).distinct
      end

      if params[:search]
        @activities = @activities.search(params[:search])
      end
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def list_user_friends
    if user_signed_in?
      @friendships = current_user.friendships.joins('INNER JOIN users ON users.id = friend_id').
          select('friendships.id, users.id AS user_id, users.name, users.email, friendships.added_on')
      @pendingFriends = @friendships.pending
      @requestedFriends = @friendships.requested
      @trueFriends = @friendships.accepted
      @friendsActivities = current_user.friends.joins(:friendships).
          where("friendships.status = 'accepted'").distinct.joins(:sports).joins('INNER JOIN places ON places.id = activities.place_id').
          select('users.id, users.name AS user_name, users.email, activities.*, sports.name AS sport_name, places.name AS place_name')
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def list_user_teams
    if user_signed_in?
      @teams = current_user.teams
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def leaderboard
    if user_signed_in?
      @sport = Sport.find(params[:id])
      @friendships = current_user.friendships.accepted.joins('INNER JOIN users ON users.id = friend_id').
          select('users.id AS leader_id, users.name, users.email')
      @leadersDuration = @friendships.joins('INNER JOIN user_activities ON user_activities.user_id = leader_id INNER JOIN activities
          ON activities.id = user_activities.activity_id INNER JOIN sports ON sports.id = activities.sport_id').where(sports: { id: @sport.id }).
          group('users.id').select('users.name, SUM(user_activities.duration) AS total_duration').order('total_duration DESC')
      @leadersFrequency = @friendships.joins('INNER JOIN user_activities ON user_activities.user_id = leader_id INNER JOIN activities
          ON activities.id = user_activities.activity_id INNER JOIN sports ON sports.id = activities.sport_id').where(sports: { id: @sport.id }).
          group('users.id').select('users.name, COUNT(activities.id) AS frequency').order('frequency DESC')
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

end
