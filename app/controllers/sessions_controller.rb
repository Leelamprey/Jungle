class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])

    # check user exist and password accurate
    if user && user.authenticate(params[:password])

      # Save userid cookie so they stay logged in
      session[:user_id] = user.id
      redirect_to :root

    else 
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end