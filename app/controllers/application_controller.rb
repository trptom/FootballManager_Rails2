# coding:utf-8
include ApplicationHelper 
include PermissionsHelper

# Default controller of application. All other controllers derives from it.
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :premissions_filter
end
