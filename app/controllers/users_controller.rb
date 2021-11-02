class UsersController < ApplicationController

  def index
    if session[:current_user]
      redirect_to home_path
    end
  end

  def login
    authenticate_user!
  end

  def logout
    session[:current_user] = nil
    redirect_to root_path
  end

end