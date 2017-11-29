class AlbumRating < ApplicationRecord
  belongs_to :user
  belongs_to :album
  validates :user_id, presence: true
  validates :album_id, presence: true
  validates :rate , presence: true , :inclusion => 1..10
  validates_uniqueness_of :album_id,    :scope => :user_id


end
