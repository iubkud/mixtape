class SongsController < ApplicationController
  before_action :set_playlist
  before_action :set_playlist_song, only: [:show, :update, :destroy]

  def index
    json_response(@playlist.songs)
  end

  def show
    json_response(@song)
  end
  
  def create
    @playlist.songs.create!(song_params)
    json_response(@playlist, :created)
  end
  
  def update
    @song.update(song_params)
    head :no_content
  end
  
  def destroy
    @song.destroy
    head :no_content
  end
  
  private

  def song_params
    params.permit(:title, :artist, :length)
  end
  
  def set_playlist
    @playlist = Playlist.find(params[:playlist_id])
  end
  
  def set_playlist_song
    @song = @playlist.songs.find_by!(id: params[:id]) if @playlist
  end  
end
