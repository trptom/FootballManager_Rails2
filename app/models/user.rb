# coding:utf-8

class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  has_many :teams

  attr_accessible :activation_expires_at, :activation_state, :activation_token,
    :password, :password_confirmation, :salt, :authentications_attributes,
    :username, :email, :first_name, :second_name, :role,
    :blocked, :block_expires_at
  
  def is_blocked
    if block_expires_at != nil
      if Time.current > block_expires_at
        unblock
        return false
      else
        return true
      end
    else
      return blocked
    end
  end

  def block(to_date = nil)
    logger.debug "blocking until: " + to_date
    update_attributes(
      :block_expires_at => to_date,
      :blocked => true
    )
    save
  end

  def unblock
    update_attributes(
      :block_expires_at => nil,
      :blocked => false
    )
    save
  end

  def is_active
    return activation_state == "active"
  end

  def has_one_team
    return teams.count == 1
  end
  
  def leagues_of_teams(season)
    competitions = []
    for team in teams
      competitions << team.league_teams.w
    end
    competitions.uniq
    
    return competitions
  end
  
  ##############################################################################
  # staticke metody
  ##############################################################################

  def self.get_first_free_name(origin)
    name = origin
    id = 1
    while User.where(:username => name).all.count > 0
      logger.info "name " + name + " already in use"
      name = origin + (++id).to_s
      logger.info "changing name to " + name
    end
    return name
  end

  ##############################################################################
  # ruby callbacky
  ##############################################################################

  validates :username,
    :format => { :with => /^[a-zA-Z0-9\-\.\_]{3,30}$/, :message => I18n.t("validation.user.username.format") },
    :uniqueness => { :case_sensitive => false, :message => I18n.t("validation.user.username.uniqueness") }

  validates :email,
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => I18n.t("validation.user.email.format") },
    :uniqueness => { :case_sensitive => false, :message => I18n.t("validation.user.email.uniqueness") }

  validates :password,
    :length => { :minimum => 3, :maximum => 255, :message => I18n.t("validation.user.password.length") },
    :confirmation => { :message => I18n.t("validation.user.password.confirmation") },
    :allow_blank => false,
    :allow_nil => false,
  :if => :password

  validates :first_name,
    :format => { :with => /^(|.{2,})$/, :message => I18n.t("validation.user.first_name") },
    :allow_nil => true,
    :allow_blank => true

  validates :second_name,
    :format => { :with => /^(|.{2,})$/, :message => I18n.t("validation.user.second_name") },
    :allow_nil => true,
    :allow_blank => true
end
