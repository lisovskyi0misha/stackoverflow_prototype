class ChangeVotesToPolymorphic < ActiveRecord::Migration[7.0]
  def change
    rename_column :votes, :answer_id, :votable_id
    add_column :votes, :votable_type, :string, null: false, default: 'Answer'
    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
