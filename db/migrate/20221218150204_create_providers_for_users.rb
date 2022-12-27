class CreateProvidersForUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string 'uid'
      t.string 'provider_name'
      t.references :user, foreign_key: true, null: false, index: true
      t.timestamps
    end
  end
end
