require 'rails_helper'

RSpec.describe 'Songs API' do
  let(:user) { create(:user) }
  let!(:playlist) { create(:playlist, created_by: user.id) }
  let!(:songs) { create_list(:song, 20, playlist_id: playlist.id) }
  let(:playlist_id) { playlist.id }
  let(:id) { songs.first.id }
  let(:headers) { valid_headers }

  describe 'GET /playlists/:playlist_id/songs' do
    before { get "/playlists/#{playlist_id}/songs", params: {}, headers: headers }

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
    before { get "/playlists/#{playlist_id}/songs/#{id}", params: {}, headers: headers }

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
    let(:valid_attributes) { { title: 'My New Song', artist: 'The Best Band', length: '300' }.to_json }

    context 'when request attributes are valid' do
      before do 
        post "/playlists/#{playlist_id}/songs", params: valid_attributes, headers: headers
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when an invalid request' do
      before { post "/playlists/#{playlist_id}/songs", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end
  
  describe 'PUT /playlists/:playlist_id/songs/:id' do
    let(:valid_attributes) { { title: 'Newest Song', artist: 'Fancy Band', length: '400' }.to_json }

    before do
      put "/playlists/#{playlist_id}/songs/#{id}", params: valid_attributes, headers: headers
    end

    context 'when song exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
      
      it 'updates the song' do
        updated_song = Song.find(id)
        expect(updated_song.title).to match(/Newest Song/)
      end
    end
    
    context 'when the song does not exists' do
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
    before { delete "/playlists/#{playlist_id}/songs/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
