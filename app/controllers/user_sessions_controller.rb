# coding:utf-8

class UserSessionsController < ApplicationController
  before_filter :require_login, :only => [:destroy]

  def create
    respond_to do |format|
      if params[:username] && params[:password] &&
          @user = login(params[:username],params[:password])
        if @user.is_blocked
          logout
          format.html {
            redirect_to("/", notice: I18n.t("messages.user_sessions.create.banned"))
          }
          format.json {
            render :json => { :state => false }
          }
        else
          format.html {
            redirect_to("/", notice: I18n.t("messages.user_sessions.create.succesfull"))
          }
          format.json {
            render :json => {
              :state => true,
              :user => @user
            }
          }
        end
      else
        format.html {
          redirect_to( :back, notice: I18n.t("messages.user_sessions.create.failed") )
        }
        format.json {
          render :json => { :state => false }
        }
      end
    end
  end

  def destroy
    logout
    redirect_to( "/", :notice => I18n.t("messages.user_sessions.destroy.succesfull"))
  end
end