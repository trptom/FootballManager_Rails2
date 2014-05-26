module PermissionsHelper
  # atts musi mit
  #   :role - Hledana role. Pokud neni uvedena, vraci vzdy true.
  # atts muzou mit
  #   :user - Pokud neni uvedeno, je pouzit current_user, pokud neni nikdo
  #           prihlasen, pocita se s tim, ze roli nema (pokud je nejaka role
  #           uvedena; pokud neni uvedena, vraci true).
  #         - Musi byt typu User.
  def has_role(atts)
    if !atts[:role]
      return true
    end

    atts[:user] = atts[:user] ? atts[:user] : current_user
    if !atts[:user] || !atts[:user].is_a?(User)
      return false
    end

    for role in atts[:user].role
      if role.to_s == atts[:role].to_s
        return true
      end
    end

    return false
  end

  # atts musi mit
  #   :role - Hledana skupina roli (pole). Pokud neni uvedena, vraci vzdy true.
  #           Pokud je uvedena vola se na kazde z nich has_role.
  # atts muzou mit
  #   :user - Predava se jako parametr funkci has_role.
  def has_at_least_one_of_roles(atts)
    if !atts[:roles]
      return true
    end

    for role in atts[:roles]
      if has_role( { :role => role, :user => atts[:user] } )
        return true
      end
    end

    return false
  end

  def premissions_filter
    has_access({})
  end

  # atts muze obsahovat:
  #   :controller - Nazev controlleru. Pokud neni uveden, je nacten z params
  #                 prohlizece.
  #   :action - Akce controlleru. Pokud neni uvedena, je nactena z params
  #             prohlizece.
  #   :user - Uzivatel, pro ktereho se zkouma. Pokud neni uveden, je pouzit
  #           current_user. Musi byt tridy User.
  def has_access(atts)
    atts[:controller] = atts[:controller] ? atts[:controller] : params[:controller]
    atts[:action] = atts[:action] ? atts[:action] : params[:action]
    atts[:user] = atts[:user] && atts[:user].is_a?(User) ? atts[:user] : current_user
    atts[:entity_id] = params[:id] ? params[:id] : nil

    logger.debug "atts[:controller]: " + atts[:controller]
    logger.debug "atts[:action]: " + atts[:action]
    logger.debug "atts[:user]: " + (atts[:user] ? atts[:user].username : "")
    logger.debug "atts[:entity_id]: " + (atts[:entity_id] ? atts[:entity_id].to_s : "")

    case atts[:controller]
    when "comments"
      @res = comments_filter(atts[:action], {
        :user => atts[:user],
        :comment_id => atts[:entity_id]
      })
    when "users"
      @res = users_filter(atts[:action], {
        :user => atts[:user],
        :entity_id => atts[:entity_id]
      })
    when "players"
      @res = players_filter(atts[:action], {
        :user => atts[:user],
        :player_id => atts[:entity_id]
      })
    when "leagues"
      @res = leagues_filter(atts[:action], {
        :user => atts[:user],
        :league_id => atts[:entity_id]
      })
    when "teams"
      @res = teams_filter(atts[:action], {
        :user => atts[:user],
        :team_id => atts[:entity_id]
      })
    when "games"
      @res = games_filter(atts[:action], {
        :user => atts[:user],
        :game_id => atts[:entity_id]
      })
    when "halls"
      @res = halls_filter(atts[:action], {
        :user => atts[:user],
        :hall_id => atts[:entity_id]
      })
    when "images"
      @res = images_filter(atts[:action], {
        :user => atts[:user],
        :image_id => atts[:entity_id]
      })
    when "plugins"
      @res = plugins_filter(atts[:action], {
        :user => atts[:user],
      })
    when "wikis"
      @res = wikis_filter(atts[:action], {
        :user => atts[:user],
      })
    when "events"
      @res = events_filter(atts[:action], {
        :user => atts[:user],
      })
    else
      @res = true
    end

    # kdyz nemam prava, nemam pristup
    if !@res
      access_denied
    end
  end

  ##############################################################################
  # SPECIFICKE FILTRY PRO CONTROLLERY
  ##############################################################################

  def articles_filter(action, atts)
    article = atts[:article] ? atts[:article] : (atts[:article_id] ? Article.find_by_id(atts[:article_id]) : nil)

    case action
    when "show", "newest", "best"
      return true
    when "new", "create", "edit", "update", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :articles_editor ],
        :user => atts[:user]
      })
    when "set_mark"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :marker ],
        :user => atts[:user]
      }) && article && article.user.id != atts[:user].id # nesmi znamkovat vlastni
    else
      return false
    end
  end

  def comments_filter(action, atts)
    comment = atts[:comment] ? atts[:comment] : (atts[:comment_id] ? Comment.find_by_id(atts[:comment_id]) : nil)

    case action
    when "show"
      return true
    when "new", "create", "react"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :commenter ],
        :user => atts[:user]
      })
    when "edit", "update", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :comments_editor ],
        :user => atts[:user]
      }) && comment.comments.length == 0 # || (comment && atts[:user] == comment.user) # pro mazani vlastnich
    else
      logger.info "ACCESS DENIED, atts: " + atts.to_s
      return false
    end
  end

  def users_filter(action, atts)
    user = atts[:entity] ? atts[:entity] : (atts[:entity_id] ? User.find_by_id(atts[:entity_id]) : nil)

    case action
    when "show"
      return true
    when "edit", "update", "change_password", "update_password"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      }) || atts[:user] == user
    when "new", "create"
      return !current_user
    when "block"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      }) && user && user.id != current_user.id &&
      user.username != ROOT_ACCOUNT_USERNAME
    when "unblock"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      }) && user && user.id != current_user.id && user.is_blocked
    when "activate"
      return true
    when "activate_manually"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      }) && user && user.id != current_user.id && !user.is_active
    when "index"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      })
    when "destroy"
      return true # TODO docasne, abych pri testech mohl mazat
    when "edit_role" # specialni akce na editaci roli, role jsou editovany v edit akci
      has_at_least_one_of_roles({
        :roles => [ :root, :admin, :users_editor ],
        :user => atts[:user]
      }) && user && atts[:user] && user.id != atts[:user].id &&
      user.username != ROOT_ACCOUNT_USERNAME
    else
      return false
    end
  end

  def leagues_filter(action, atts)
    league = atts[:league] ? atts[:league] : (atts[:league_id] ? League.find_by_id(atts[:league_id]) : nil)

    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :leagues_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def players_filter(action, atts)
    player = atts[:player] ? atts[:player] : (atts[:player_id] ? Player.find_by_id(atts[:player_id]) : nil)

    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :players_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def halls_filter(action, atts)
    hall = atts[:hall] ? atts[:hall] : (atts[:hall_id] ? League.find_by_id(atts[:hall_id]) : nil)

    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :halls_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def games_filter(action, atts)
    game = atts[:game] ? atts[:game] : (atts[:game_id] ? League.find_by_id(atts[:game_id]) : nil)

    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :games_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def teams_filter(action, atts)
    team = atts[:team] ? atts[:team] : (atts[:team_id] ? Team.find_by_id(atts[:team_id]) : nil)

    logger.debug "team: " + (team ? team.id.to_s : "")

    case action
    when "about"
      return true
    when "show", "edit", "update", "new_team", "new_club", "create", "index_of_clubs", "index_of_teams"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :teams_editor ],
        :user => atts[:user]
      })
    when "destroy"
      logger.debug "players count: " + team.players.count.to_s

      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :teams_editor ],
        :user => atts[:user]
      }) && team && team.players.count == 0
    when "squad"
      return (!team || (team && team.squad_viewable)) ? true : has_at_least_one_of_roles({
        :roles => [ :root, :admin, :teams_editor ],
        :user => atts[:user]
      })
    when "games"
      return (!team || (team && team.games_viewable)) ? true : has_at_least_one_of_roles({
        :roles => [ :root, :admin, :teams_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def images_filter(action, atts)
    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :images_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end
  
  def wikis_filter(action, atts)
    case action
    when "show"
      return true
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :wikis_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end
  
  def events_filter(action, atts)
    case action
    when "edit", "update", "new", "create", "index", "destroy"
      return has_at_least_one_of_roles({
        :roles => [ :root, :admin, :events_editor ],
        :user => atts[:user]
      })
    else
      return false
    end
  end

  def plugins_filter(action, atts)
    # TODO
    return true
  end
end
