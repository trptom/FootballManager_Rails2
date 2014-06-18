# coding:utf-8

# Controller for UserSessions. It is used for login and logout of User.
class UserSessionsController < ApplicationController
  
  # Creates new UserSessions for User depending on passed +username+ and
  # +password+.
  #
  # ==== Required params
  # _username_:: login of user.
  # _password_:: password of user.
  def create
    if params[:username] && params[:password] &&
        @user = login(params[:username],params[:password])
      if @user.is_blocked
        logout
        redirect_to( :back, notice: I18n.t("messages.user_sessions.create.banned"))
      else
        # select page where to redirect
        page = current_user.teams.count > 0 ? "/" : "/users/select_team"
        
        redirect_to(page, notice: I18n.t("messages.user_sessions.create.succesfull"))
      end
    else
      redirect_to( :back, notice: I18n.t("messages.user_sessions.create.failed") )
    end
  end

  # Deletes current UserSession and redirects to root.
  def destroy
    logout
    redirect_to( "/", :notice => I18n.t("messages.user_sessions.destroy.succesfull"))
  end
end