# Helper used globally for working with permissions and their checking. Should
# be included in ApplicationController.
module PermissionsHelper
  
  # Filter used in ApplicationController. It must be defined because in
  # ApplicationController i don't have access to +current_user+ during
  # initialization.
  def premissions_filter
    # check page availability
    if !PermissionsHelper::is_page_available(current_user, params[:controller], params[:action], params)
      Rails.logger.info "access deined (#{current_user.to_s}, #{params[:controller]}, #{params[:action]})"
      ApplicationHelper::access_denied
    end
  end
  
  # Disabled pages for logged off user. Keys are controller names which will
  # contain hash of disabled actions. Each action should have assigned true
  # value. When controller contains true value, all its actions are disabled.
  LOGGED_OFF_FILTER = {
    
  }
  
  # Disabled pages for logged on user. Keys are controller names which will
  # contain hash of disabled actions. When controller contains nil value, all
  # its actions are disabled.
  LOGGED_ON_FILTER = {
    
  }
  
  # Pages that will be available only for administrator.
  ADMIN_PAGES = {
    
  }
  
  # Checks page availability (not depends whether user is logged on or off).
  #
  # ==== Params
  # _user_:: user for who is page availability checked. When nil, page 
  #          is checked for not logged user.
  # _controller_:: name of checked controller (String).
  # _action_:: name of checked action (String).
  # _params_:: parameters passed to page (Hash).
  #
  # ==== Returns
  # _boolean_:: true when page should be available, false otherwise.
  def is_page_available(user, controller, action, params = nil)
    if user != nil
      return PermissionsHelper::is_page_available_logged_on(user, controller, action, params)
    else
      return PermissionsHelper::is_page_available_logged_off(controller, action, params)
    end
  end
  
  # Checks page availability for logged on user.
  #
  # ==== Params
  # _user_:: user for who is page availability checked. Shouldn't be nil.
  # _controller_:: name of checked controller (String).
  # _action_:: name of checked action (String).
  # _params_:: parameters passed to page (Hash).
  #
  # ==== Returns
  # _boolean_:: true when page should be available, false otherwise.
  def is_page_available_logged_on(user, controller = nil, action = nil, params = nil)
    # when page is in list of disabled pages
    if LOGGED_OFF_FILTER[controller] == true ||
       (LOGGED_OFF_FILTER[controller] && LOGGED_OFF_FILTER[controller][action] == true)
     return false
    end

    # when page is allowed only for admin
    if ADMIN_PAGES[controller] == true ||
       (ADMIN_PAGES[controller] && ADMIN_PAGES[controller][action] == true)
     return false
    end
    
    # handle special pages
    case controller
    when "user"
      case action
      when "select_team", "update_team"
        return user.teams.count == 0
      end
    else
      # when no special allow it
      return true;
    end
  end
  
  # Checks page availability when user is not logged on.
  #
  # ==== Params
  # _controller_:: name of checked controller (String).
  # _action_:: name of checked action (String).
  # _params_:: parameters passed to page (Hash).
  #
  # ==== Returns
  # _boolean_:: true when page should be available, false otherwise.
  def is_page_available_logged_off(controller = nil, action = nil, params = nil)
    # when page is in list of disabled pages
    if LOGGED_ON_FILTER[controller] == true ||
       (LOGGED_ON_FILTER[controller] && LOGGED_ON_FILTER[controller][action] == true)
     return false
    end

    # when page is allowed only for admin
    if ADMIN_PAGES[controller] == true ||
       (ADMIN_PAGES[controller] && ADMIN_PAGES[controller][action] == true)
     return false
    end
  end
end
