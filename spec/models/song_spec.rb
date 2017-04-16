require 'rails_helper'

RSpec.describe Song, type: :model do
  # should belong to Playlist
  it { should belong_to(:playlist) }

  # check columns title, artist, and length
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:artist) }
  it { should validate_presence_of(:length) }
end
