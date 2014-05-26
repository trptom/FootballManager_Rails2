class Player < ActiveRecord::Base
  attr_accessible :age, :aggresivness, :att, :def, :first_name, :foot, :gk,
    :last_name, :mid, :passing, :potential, :pseudonym, :quality,
    :second_name, :shooting, :speed, :stamina, :icon
  
  belongs_to :country
end
