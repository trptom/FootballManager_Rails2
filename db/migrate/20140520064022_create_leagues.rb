class CreateLeagues < ActiveRecord::Migration
  def add_league(shortcut, level, group, country)
    League.new(
      :shortcut => shortcut,
      :league_type => LEAGUE_TYPE_STANDARD,
      :type_data => nil, # u LEAGUE_TYPE_STANDARD ekvivalent pro { :against => 2 }
      :level => level,
      :grp => group,
      :country => country
    ).save
  end
  
  def add_cup(shortcut, country)
    League.new(
      :shortcut => shortcut,
      :league_type => LEAGUE_TYPE_CUP,
      :type_data => nil, # u LEAGUE_TYPE_STANDARD ekvivalent pro { :against => 2 }
      :level => 1,
      :grp => nil,
      :country => country
    ).save
  end
  
  def add_champions_cup
    League.new(
      :shortcut => "CC",
      :league_type => LEAGUE_TYPE_CHAMPIONS_CUP,
      :type_data => nil, # champions cup je jen jeden, nepotrebuje dodatecne nastaveni
      :level => 1,
      :grp => nil,
      :country => nil
    ).save
  end
  
  def fill_country_by_leagues(country)
    add_cup(country.shortcut + "_CUP", country)
    
    add_league(country.shortcut + "1", 1, nil, country)
    add_league(country.shortcut + "2", 2, nil, country)
    add_league(country.shortcut + "3A", 3, 1, country)
    add_league(country.shortcut + "3B", 3, 2, country)
    add_league(country.shortcut + "4A", 4, 1, country)
    add_league(country.shortcut + "4B", 4, 2, country)
    add_league(country.shortcut + "4C", 4, 3, country)
    add_league(country.shortcut + "4D", 4, 4, country)
    add_league(country.shortcut + "5A", 5, 1, country)
    add_league(country.shortcut + "5B", 5, 2, country)
    add_league(country.shortcut + "5C", 5, 3, country)
    add_league(country.shortcut + "5D", 5, 4, country)
  end
  
  def change
    create_table :leagues do |t|
      t.string :shortcut,     :null => false
      t.references :country,  :null => true, :default => nil
      t.integer :league_type, :null => false
      t.text :type_data,      :null => true, :default => nil
      t.integer :level,       :null => false, :default => 1
      t.integer :grp,       :null => true, :default => nil
      t.string :logo,         :null => true, :default => nil

      t.timestamps
    end
    
    add_index :leagues, :country_id
    
    for c in Country.all
      fill_country_by_leagues(c)
    end
    
    add_champions_cup
  end
end
