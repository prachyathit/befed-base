class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # To empty cache when using browser back button
  before_filter :set_cache_headers, 
    :clear_old_session_address # to remove old formatted session address

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def clear_old_session_address
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.tagged("Test") { logger.info "SESSION" }
    logger.tagged("Test") { logger.info session.inspect }
    if session[:saddress].present? and (
      not session[:saddress]['raw'].present? or (
        session[:saddress]['raw'].present? and
        not session[:saddress]['raw']['latitude'].present? and 
        not session[:saddress]['raw']['longitude'].present?)
      )
      session[:saddress] = {}
    end
  end

end
