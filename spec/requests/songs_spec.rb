require 'rails_helper'

RSpec.describe 'Songs API' do
  let!(:playlist) { create(:playlist) }
  let!(:songs) { create_list(:song, 20, playlist_id: playlist.id) }
  let(:playlist_id) { playlist.id }
  let(:id) { songs.first.id }

  describe 'GET /playlists/:playlist_id/songs' do
    before { get "/playlists/#{playlist_id}/songs" }

    context 'when song exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns all playlist songs' do
        expect(json.size).to eq(20)
      end
    end
    
    context 'when playlist does not exist' do
      let(:playlist_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Playlist/)
      end
    end
  end
  
  describe 'GET /playlists/:playlist_id/songs/:id' do
    before { get "/playlists/#{playlist_id}/songs/#{id}" }

    context 'when playlist song exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the song' do
        expect(json['id']).to eq(id)
      end
    end
    
    context 'when the song does not exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end
  end
  
  describe 'POST /playlists/:playlist_id/songs' do
    let(:valid_attributes) { { title: 'My New Song', artist: 'The Best Band', length: '300' } }

    context 'when request attributes are valid' do
      before { post "/playlists/#{playlist_id}/songs", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when an invalid request' do
      before { post "/playlists/#{playlist_id}/songs", params: { } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end
  
  describe 'PUT /playlists/:playlist_id/songs/:id' do
    let(:valid_attributes) { { title: 'Newest Song', artist: 'Fancy Band', length: '400' } }

    before { put "/playlists/#{playlist_id}/songs/#{id}", params: valid_attributes }

    context 'when song exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
      
      it 'updates the song' do
        updated_song = Song.find(id)
        expect(updated_song.title).to match(/Newest Song/)
      end
    end
    
    context 'when the item does not exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end
  end
  
  describe 'DELETE /playlists/:playlist_id/songs/:id' do
    before { delete "/playlists/#{playlist_id}/songs/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
