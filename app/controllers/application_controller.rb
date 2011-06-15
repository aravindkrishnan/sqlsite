class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def admin_required
       unless current_user && current_user.is_admin?
         flash[:error] = "Sorry, you don't have access to that."
         redirect_to '/users' and return false
       end
  end
  def user_required
       unless current_user && current_user.is_user?
         flash[:error] = "Sorry, you don't have access to that."
         redirect_to '/users' and return false
       end
  end

  def admin_or_user_required
    unless current_user && ( current_user.is_user? || current_user.is_admin?)
       flash[:error] = "Sorry, you don't have access to that."
       redirect_to '/users' and return false
    end
  end
end