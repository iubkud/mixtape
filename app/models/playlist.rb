class Playlist < ApplicationRecord
  has_many :songs, dependent: :destroy

  validates_presence_of :title, :created_by
end
