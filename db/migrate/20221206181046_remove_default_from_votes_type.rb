class RemoveDefaultFromVotesType < ActiveRecord::Migration[7.0]
  def change
    change_column_default :votes, :votable_type, from: 'Answer', to: nil
  end
end
