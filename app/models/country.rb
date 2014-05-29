class Country < ActiveRecord::Base
  attr_accessible :shortcut, :image
  
  has_many :players
  has_many :teams
  has_many :leagues
  has_many :country_coefs
  has_many :player_names
  
  def get_position
    coefs = CountryCoef.ordered_by_sum
    a = 1
    
    for c in coefs
      if c.country_id == id
        return a
      end
      a = a + 1
    end
    
    return nil
  end
  
  def get_qualyfication
    return CountryCoefQualyfication.by_pos(get_position)
  end
  
  def get_flag_url(type)
    return ActionController::Base.helpers.asset_path(File.join(type, shortcut.downcase + ".png"))
  end
  
  def get_flag_img(type)
    url = get_flag_url(type)
    return ActionController::Base.helpers.image_tag(url, title: I18n.t("countries." + shortcut))
  end
  
  def get_i18n_message
    return COUNTRY_MESSAGES_KEY + shortcut
  end
end
