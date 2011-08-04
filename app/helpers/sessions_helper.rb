module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
#    logger.debug "current_user gettr" + @current_user.to_s
    @current_user = user_from_remember_token if @current_user.nil?
#    logger.debug "current_user gettr after check" + @current_user.to_s
    return @current_user
    #@current_user ||= user_from_remember_token
  end

  def signed_in?
#    logger.debug "in signed in"
#    return false if self.current_user.nil?
#    logger.debug "past self.current_user.nil? check"
#    logger.debug self.current_user.nil?
    !current_user.nil?
#    current_user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
#    logger.debug "self.current_user set to nil"
#    @current_user = nil
#    logger.debug "@current_user set to nil"
#    if signed_in?
#      logger.debug "Problem, think it is signed in."
#    end
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
