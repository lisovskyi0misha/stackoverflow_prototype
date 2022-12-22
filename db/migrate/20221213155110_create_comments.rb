class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.string :body
      t.timestamps

      t.index [:commentable_id, :commentable_type]
      t.index [:commentable_id, :commentable_type, :user_id], name: 'index_comments_on_commentable_type_and_id_and_user_id'
    end
  end
end
