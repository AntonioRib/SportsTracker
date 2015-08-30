class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :checkSession, only: [:edit, :update]
  before_action :checkSessionIfFriend, only: [:show]
  after_action :addActivityToUser, only: [:create, :join_in]
  after_action :updateActivityOnUser, only: [:update]

  # GET /activities/1
  # GET /activities/1.json
  def show
    @activity = Activity.find(params[:id])
    respond_to do |format|
        format.html
        format.json { render json: @activity}
    end
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  def join_in
    @activity = Activity.find(params[:id])
    redirect_to '/list_user_activities', notice: 'You have successfully joined in on the selected activity!'
  end

  # POST /activities
  # POST /activities.json
  def create
    ap = activity_params
    if !ap[:points].nil?
      doc = Nokogiri::XML(ap[:points].read)
      parse_gpx(doc,ap)
    end
    @activity = Activity.new(ap)
    @activity.owner_id = current_user.id

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    ap = activity_params
    if !ap[:points].nil?
      doc = Nokogiri::XML(ap[:points].read)
      parse_gpx(doc,ap)
    end

    respond_to do |format|
      if @activity.update(ap)
        @activity.save

        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def parse_gpx(doc,ap)
    trackpoints = doc.xpath('//xmlns:trkpt')
    @points = Array.new
    trackpoints.each do |trkpt|
      @points << [trkpt.xpath('@lat').to_s.to_f, trkpt.xpath('@lon').to_s.to_f]
    end
    ap[:points] = @points
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @user_activity = current_user.user_activities.find_by(user_id: current_user.id)

    if @activity.owner_id == current_user.id
      @activity.destroy
    elsif !@user_activity.nil?
          @user_activity.destroy
    else
      render file: 'app/views/errors/forbidden_access.html', status: :unauthorized
    end

    respond_to do |format|
      format.html { redirect_to list_user_activities_path, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:name, :date, :points, :place_id, :sport_id, :owner_id)
    end

    def addActivityToUser
      @activity.user_activities.build(user_id: current_user.id, activity_id: @activity.id, duration: params['duration'])
      @activity.save
    end

    def updateActivityOnUser
      @activity.user_activities.find_by(user_id: current_user.id, activity_id: @activity.id).update(duration: params['duration'])
    end

    def checkSession
      unless @activity.owner_id == current_user.id
        render file: 'app/views/errors/forbidden_access.html', status: :unauthorized
      end
    end

    def checkSessionIfFriend
      @activity = Activity.find(params[:id])
      @friendships = Friendship.find_by(user_id: @activity.owner_id, friend_id: current_user.id, status: 'accepted')
      if @friendships.nil? && @activity.owner_id != current_user.id
        render file: 'app/views/errors/forbidden_access.html', status: :unauthorized
      end
    end
end
