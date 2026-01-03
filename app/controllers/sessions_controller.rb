class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]
  before_action :redirect_if_signed_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to stored_location_or(boards_path), notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to sign_in_path, notice: "You have been signed out."
  end

  private

  def redirect_if_signed_in
    redirect_to boards_path if signed_in?
  end
end
