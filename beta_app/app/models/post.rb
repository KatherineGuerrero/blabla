class Post < ApplicationRecord
	belongs_to :user
	# length validation of post
	# and not blank
	validates :content, length: { maximum: 140, too_long: ": Sobrepasaste
									el máximo de caracteres 
									permitidos (%{count})"},
						presence: true
	# validates :user_id, :presence => {:message => ": Debe existir el ususario creador"}
	validates_associated :user
end
