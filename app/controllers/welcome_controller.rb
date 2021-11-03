# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def home
    @current_user = session[:current_user]
  end
end
