class SearchController < ApplicationController
  def index
    @artists = RSpotify::Artist.search(params[:term])
    @tracks = RSpotify::Track.search(params[:term])
    @albums = RSpotify::Album.search(params[:term])
    @search_results = {"artists" => @artists,
                       "tracks"  => @tracks,
                       "albums"  => @albums}.to_json
    json_response(@search_results)
  end
end
