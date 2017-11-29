class UserComment < ApplicationRecord
  belongs_to :author , class_name: "User"
  belongs_to :mentioned , class_name: "User"

  validates :author_id , presence: true
  validates :mentioned_id ,presence: true
  validates :comment, length: { maximum: 120, too_long: ": Sobrepasaste
									el máximo de caracteres
									permitidos (%{count})"},
						presence: true
end
