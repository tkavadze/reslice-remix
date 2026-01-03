class RegistrationsController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]
  before_action :redirect_if_signed_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)
      redirect_to boards_path, notice: "Welcome to Kanban! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_if_signed_in
    redirect_to boards_path if signed_in?
  end
end
