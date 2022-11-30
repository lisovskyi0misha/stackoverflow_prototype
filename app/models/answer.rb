class Answer < ApplicationRecord
  validates_presence_of :body
  belongs_to :question
  has_many_attached :files
end
