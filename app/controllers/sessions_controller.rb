class SessionsController < ApplicationController
  def new
  end

  def create
    # If user is authenticated
    if user = User.authenticate_with_credentials(params[:email], params[:password])
      # Save userid cookie to not log out
      session[:user_id] = user.id
      redirect_to :root
    else 
      render :new
    end
  end

  def destroy
    # delete cookie
    session[:user_id] = nil
    redirect_to :root
  end
end