class AlbumsController < ApplicationController
  before_action :redirect_unless_logged_in

  def show
    find_album!
  end

  def new
    @artist = Artist.find(params[:artist_id])
    @album = Album.new
  end

  def create
    temp_params = album_params
    temp_params[:live] = temp_params[:live] == "true"
    @artist = Artist.find(params[:artist_id])

    @album = @artist.albums.new(temp_params)
    if @album.save
      inform("album \"#{@album.name}\" created")
      redirect_to artist_url(@artist)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def edit
    find_album!
  end

  def update
    find_album!
    if @album.update(album_params)
      inform("album \"#{@album.name}\" updated")
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def destroy
    find_album!
    @artist = @album.artist
    inform("album \"#{@album.name}\" deleted")
    @album.destroy
    redirect_to artist_url(@artist)
  end

  private

  def album_params
    params.require(:album).permit(:name, :live)
  end

  def find_album!
    @album = Album.find(params[:id])
  end
end
