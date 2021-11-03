# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    redirect_to home_path if session[:current_user]
  end

  def login
    authenticate_user!
  end

  def logout
    session[:current_user] = nil
    redirect_to root_path
  end
end
