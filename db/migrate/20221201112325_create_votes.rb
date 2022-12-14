class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :answer, foreign_key: true, null: false
      t.integer :status, null: false
      t.timestamps
    end
  end
end
