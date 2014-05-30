class CreateGameComments < ActiveRecord::Migration
  def change
    create_table :game_comments do |t|
      t.references :user,   :null => false
      t.references :game,   :null => false
      t.text :content,      :null => false

      t.timestamps
    end
    
    add_index :game_comments, :user_id
    add_index :game_comments, :game_id
  end
end
