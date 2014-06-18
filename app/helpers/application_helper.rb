# Helper, containing function that may be used across whole application. This
# helper should be loaded in ApplicationController.
module ApplicationHelper
  
  # Should be called when you want to emulate that page wasnt found. This method
  # will do redirect to equivalent error page.
  def page_not_found
    redirect_to NOT_FOUND_PAGE_URL
  end

  # Should be called when wrong params of page were passed (e.g. some of needed
  # params like +id+ is missing). This method will do redirect to equivalent
  # error page.
  def wrong_params
    page_not_found
  end

  # Should be called when access to page is denied. This method will do redirect
  # to equivalent error page.
  def access_denied
    page_not_found
  end
  
  # Determines whether team is managed by current user and when not, calls
  # #page_not_found function.
  #
  # ==== Returns
  # _Team_:: when not redirected, team passed as param is returned.
  def filter_by_current_user_team(team)
    if team == nil || team.user != current_user
      Rails.logger.warning("filtered by filter_by_current_user_team (" + team.to_s + ")")
      page_not_found
    else
      return team
    end
  end
  
  # Checks asset existency. If something fails (e.g. asset doesnt exist),
  # returns false so no error will be thrown.
  #
  # ==== Params
  # _asset_:: asset URL.
  #
  # ==== Returns
  # _boolean_:: thue when checking was ok and asset exists, false otherwise.
  def check_asset_existency(asset)
    return Rails.application.assets.find_asset asset
  rescue
    return false;
  end

  # Gets and returns array of additional page-specific stylesheets depending
  # on page and controller.
  #
  # Following scripts are loaded:
  # * skins/<_SKIN_>/page/<_controller_>/overall.css
  # * skins/<_SKIN_>/page/<_controller_>/<_action_>.css
  #
  # When some of files doesnt exist, nothing wrong happens. It is just
  # not included in returned array.
  #
  # ==== Returns
  # _Array_:: array od available page/controller specific files. When no file
  #           available, empty array is returned.
  def get_additional_styles
    ctrl_style_url = "skins/" + SKIN + "/page/" + params[:controller] + "/overall.css"
    page_style_url = "skins/" + SKIN + "/page/" + params[:controller] + "/" + params[:action] + ".css"

    res = Array.new

    if check_asset_existency ctrl_style_url
      res << "/assets/#{ctrl_style_url}"
    end

    if check_asset_existency page_style_url
      res << "/assets/#{page_style_url}"
    end
	
	logger.info "styles res: " + res.to_s

    return res
  end

  # Gets and returns array of additional page-specific javascripts depending
  # on page and controller.
  #
  # Following scripts are loaded:
  # * page/<_controller_>/overall.js
  # * page/<_controller_>/<_action_>.js
  #
  # When some of files doesnt exist, nothing wrong happens. It is just
  # not included in returned array.
  #
  # ==== Returns
  # _Array_:: array od available page/controller specific files. When no file
  #           available, empty array is returned.
  def get_additional_scripts
    ctrl_script_url = "page/" + params[:controller] + "/overall.js"
    page_script_url = "page/" + params[:controller] + "/" + params[:action] + ".js"

    res = Array.new

    if check_asset_existency ctrl_script_url
      res << "/assets/#{ctrl_script_url}"
    end

    if check_asset_existency page_script_url
      res << "/assets/#{page_script_url}"
    end
    
    return res
  end
end
