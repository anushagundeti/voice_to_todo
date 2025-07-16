class Audio < ApplicationRecord
  has_one_attached :file
  has_many :todos, dependent: :destroy
end
