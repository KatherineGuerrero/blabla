class SongRating < ApplicationRecord
  belongs_to :user
  belongs_to :song
  validates :user_id, presence: true
  validates :song_id, presence: true
  validates :rate , presence: true , :inclusion => 1..10
  validates_uniqueness_of :song_id,    :scope => :user_id
end
