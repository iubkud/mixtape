require 'rails_helper'

RSpec.describe Playlist, type: :model do
  # Playlist model has a 1:m relationship with Song model
  it { should have_many(:songs).dependent(:destroy) }

  # Make sure columns title and created_by are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
