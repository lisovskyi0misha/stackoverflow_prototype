class Question < ApplicationRecord
  validates_presence_of :title, :body
  has_many :answers
end