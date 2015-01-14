class TracksController < ApplicationController
  before_action :redirect_unless_logged_in

  def show
    find_track!
    @note = Note.new
  end

  def new
    @album = Album.find(params[:album_id])
    @track = Track.new
  end

  def create
    temp_params = track_params
    temp_params[:bonus] = temp_params[:bonus] == "true"
    @album = Album.find(params[:album_id])

    @track = @album.tracks.new(temp_params)
    if @track.save
      inform("track \"#{@track.name}\" created")
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def edit
    find_track!
  end

  def update
    find_track!
    if @track.update(track_params)
      inform("track \"#{@track.name}\" updated")
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def destroy
    find_track!
    @album = @track.album
    inform("track \"#{@track.name}\" deleted")
    @track.destroy
    redirect_to album_url(@album)
  end

  private

  def track_params
    params.require(:track).permit(:name, :bonus, :lyrics)
  end

  def find_track!
    @track = Track.find(params[:id])
  end
end
