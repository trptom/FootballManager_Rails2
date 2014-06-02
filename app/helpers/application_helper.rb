module ApplicationHelper
  def page_not_found
    redirect_to NOT_FOUND_PAGE_URL
  end

  def wrong_params
    page_not_found
  end

  def access_denied
    page_not_found
  end
  
  def filter_by_current_user_team(team)
    if team == nil || team.user != current_user
      Rails.logger.warning("filtered by filter_by_current_user_team (" + team.to_s + ")")
      page_not_found
    else
      return team
    end
  end
  
  # Checks asset existency. If something fails (e.g. asset doesnt exist),
  # returns false.
  def check_asset_existency(asset)
    logger.info "searching asset: " + asset
    return Rails.application.assets.find_asset asset
  rescue
    logger.info "asset error: " + asset
    return false;
  end

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

	logger.info "scripts res: " + res.to_s
	
    return res
  end
end
