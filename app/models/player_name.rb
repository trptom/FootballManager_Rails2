class PlayerName < ActiveRecord::Base
  belongs_to :country
  attr_accessible :first_name, :frequency, :last_name, :name_str, :pseudonym,
    :second_name, :country, :country_id
  
  scope :first_names, -> {
    where(:first_name => true)
  }
  
  scope :second_names, -> {
    where(:second_name => true)
  }
  
  scope :last_names, -> {
    where(:last_name => true)
  }
  
  scope :pseudonyms, -> {
    where(:pseudonym => true)
  }
  
  scope :first_names_c, ->(country) {
    first_names.where(:country_id => country.id)
  }
  
  scope :second_names_c, ->(country) {
    second_names.where(:country_id => country.id)
  }
  
  scope :last_names_c, ->(country) {
    last_names.where(:country_id => country.id)
  }
  
  scope :pseudonyms_c, ->(country) {
    pseudonyms.where(:country_id => country.id)
  }
end
