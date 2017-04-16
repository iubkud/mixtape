class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy]

  def index
    @playlists = current_user.playlists
    json_response(@playlists)
  end

  def create
    @playlist = current_user.playlists.create!(playlist_params)
    json_response(@playlist, :created)
  end

  def show
    json_response(@playlist)
  end

  def update
    @playlist.update(playlist_params)
    head :no_content
  end

  def destroy
    @playlist.destroy
    head :no_content
  end

  private

  def playlist_params
    params.permit(:title)
  end

  def set_playlist
    @playlist = Playlist.find(params[:id])
  end
  
end
