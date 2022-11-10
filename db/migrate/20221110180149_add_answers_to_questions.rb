class AddAnswersToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :question, foreign_key: true, null: false
  end
end
