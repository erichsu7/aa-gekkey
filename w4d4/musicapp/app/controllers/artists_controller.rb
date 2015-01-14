class ArtistsController < ApplicationController
  before_action :redirect_unless_logged_in, except: :index

  def index
    if logged_in?
      @artists = Artist.all
      render :index
    else
      @user = User.new
      render "sessions/new"
    end
  end

  def show
    find_artist!
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      inform("artist \"#{@artist.name}\" created")
      redirect_to artists_url
    else
      render :new
    end
  end

  def edit
    find_artist!
  end

  def update
    find_artist!
    if @artist.update(artist_params)
      inform("artist \"#{@artist.name}\" updated")
      redirect_to artist_url(@artist)
    else
      flash.now[:errors] = @artist.errors.full_messages
      render :edit
    end
  end

  def destroy
    find_artist!
    inform("artist \"#{@artist.name}\" deleted")
    @artist.destroy
    redirect_to artists_url
  end

  private

  def artist_params
    params.require(:artist).permit(:name)
  end

  def find_artist!
    @artist = Artist.find(params[:id])
  end
end
