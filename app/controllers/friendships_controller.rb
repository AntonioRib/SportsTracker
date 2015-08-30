class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
  before_action :checkSession, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @friendships = Friendship.all
    respond_with(@friendships)
  end

  def show
    respond_with(@friendship)
    @friendship = Friendship.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @friendship}
    end
  end

  def accept
    @friend = User.find(params[:friend])
    @friendship = Friendship.find_by(user_id: current_user.id, friend_id: @friend.id)
    @reciprocate = Friendship.find_by(user_id: @friend.id, friend_id: current_user.id)

    @friendship.status = 'accepted'
    @friendship.added_on = DateTime.now
    @reciprocate.status = 'accepted'
    @reciprocate.added_on = DateTime.now
    @friendship.save
    @reciprocate.save

    redirect_to '/list_user_friends'
  end

  def new
    @friendship = Friendship.new
    respond_with(@friendship)
  end

  def edit
  end

  def add_friend

    @friend = User.find(params[:friend])
    @friendship = Friendship.new(user_id: current_user.id, friend_id: @friend.id)
    @friendship.user_id = current_user.id
    @friendship.status = 'pending'
    @reciprocate = Friendship.new(user_id: @friendship.friend_id, friend_id: @friendship.user_id)
    @reciprocate.status = 'requested'

    if Friendship.find_by(user_id: @friendship.friend_id, friend_id: @friendship.user_id).nil?
      @friendship.save
      @reciprocate.save
    end

    redirect_to '/list_user_friends'
  end

  def update
    @friendship.update(friendship_params)
    respond_with(@friendship)
  end

  def destroy
    @friendship.destroy
    Friendship.find_by(user_id: @friendship.friend_id, friend_id: @friendship.user_id).destroy
    redirect_to '/list_user_friends', notice: 'Friendship was terminated.'
  end

  private
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end

    def checkSession
      unless @friendship.user_id == current_user.id
        render file: 'app/views/errors/forbidden_access.html', status: :unauthorized
      end
    end

end
