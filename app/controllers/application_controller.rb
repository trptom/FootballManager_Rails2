# coding:utf-8
include ApplicationHelper 
include PermissionsHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
end
