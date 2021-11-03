class ApplicationController < ActionController::Base
  private

  def authenticate_user!
    return :ok if session[:current_user].present?

    @username = params[:username]
    @password = params[:password]

    if valid_params?
      redirect_to home_path
    else
      redirect_to root_path
    end
  end

  def valid_params?
    return false unless @username.present? && @password.present?

    valid_user_credentials?
  end

  def valid_user_credentials?
    @current_user = User.find_by(username: @username)

    if @current_user 
      if Digest::MD5.hexdigest(@password) == @current_user.password
        return false unless @current_user.active?

        reset_login_attempts
        create_user_session
        return @current_user 
      else
        login_failure
        return false
      end
    else
      new_user
    end
  end

  def reset_login_attempts
    @current_user.update(login_attempts: 0) if @current_user.login_attempts > 0
  end

  def create_user_session
    session[:current_user] = @current_user
  end

  def login_failure
    if @current_user.login_attempts < 3
      @current_user.login_attempts += 1
      @current_user.save
    end
    @current_user.blocked! if @current_user.login_attempts >= 3
  end

  def new_user
    user = User.new(username: @username, password: @password)
    if user.save
      create_user_session
      return @current_user
    else
      return false
    end 
  end
end
