class Category < ApplicationRecord
  validates_presence_of :name

  belongs_to :user
  has_many :todos, dependent: :nullify
end
