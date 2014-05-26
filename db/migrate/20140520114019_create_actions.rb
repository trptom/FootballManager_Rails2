class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.text :content,    :null => false
      t.integer :type,    :null => false

      t.timestamps
    end
  end
end
