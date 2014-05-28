# coding:utf-8

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
    
    # TODO remove and generate from real data
    for c in Country.all
      PlayerName.new(:name_str => "Tomáš", :first_name => true, :second_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Karel", :first_name => true, :second_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Pavel", :first_name => true, :second_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Josef", :first_name => true, :second_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Vendelín", :first_name => true, :second_name => true, :country => c, :frequency => NAME_FREQUENCY_MIN).save
      
      PlayerName.new(:name_str => "Chocholoušek", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MIN).save
      PlayerName.new(:name_str => "Rakovets", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MIN).save
      PlayerName.new(:name_str => "Volek", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MIN).save
      PlayerName.new(:name_str => "Vobořil", :last_name => true, :country => c, :frequency => 5).save
      PlayerName.new(:name_str => "Semerád", :last_name => true, :country => c, :frequency => 5).save
      PlayerName.new(:name_str => "Mareček", :last_name => true, :country => c, :frequency => 5).save
      PlayerName.new(:name_str => "Novák", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Malý", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Bazal", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Černý", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Bílý", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
      PlayerName.new(:name_str => "Vitásek", :last_name => true, :country => c, :frequency => NAME_FREQUENCY_MAX).save
    end
    
    add_index :player_names, :country_id
    add_index :player_names, :first_name
    add_index :player_names, :second_name
    add_index :player_names, :last_name
    add_index :player_names, :pseudonym
  end
end
