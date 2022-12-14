class DeleteForeignKeyForAnswersInVotes < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :votes, :answers
  end
end
