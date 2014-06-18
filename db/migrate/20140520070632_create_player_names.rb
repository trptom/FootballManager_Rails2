# coding:utf-8

include PlayerNamesHelper

class CreatePlayerNames < ActiveRecord::Migration
  def change
    create_table :player_names do |t|
      t.string :name_str,       :nil => false
      t.boolean :first_name,    :nil => false, :default => false
      t.boolean :second_name,   :nil => false, :default => false
      t.boolean :last_name,     :nil => false, :default => false
      t.boolean :pseudonym,     :nil => false, :default => false
      t.integer :frequency,     :nil => false, :default => NAME_FREQUENCY_MAX
      t.references :country,    :nil => false

      t.timestamps
    end
    
    PlayerNamesHelper::fill_in_names(nil)
    
    add_index :player_names, :country_id
    add_index :player_names, :first_name
    add_index :player_names, :second_name
    add_index :player_names, :last_name
    add_index :player_names, :pseudonym
  end
end
