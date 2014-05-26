class CreateCountries < ActiveRecord::Migration
  def add_country(shortcut)
    @c = Country.new :shortcut => shortcut
    @c.save
  end
  
  def change
    create_table :countries do |t|
      t.string :shortcut, :null => false
      t.string :image,    :null => true, :default => nil

      t.timestamps
    end
    
    add_country("ARG")
    add_country("BRA")
    add_country("CZE")
    add_country("ENG")
    add_country("FRA")
    add_country("GER")
    add_country("ITA")
    add_country("NED")
    add_country("SPA")
    add_country("SVK")
  end
end
