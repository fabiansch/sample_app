class PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Password instructions sent to your email address."
      redirect_to root_url
    else
      flash.now[:danger] = "Given email is not known."
      render 'password_resets/new'
    end
  end

  def edit
  end

  def update
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes( password: password,
                                password_confirmation: password_confirmation,
                                password_reset_at: Time.zone.now )
      flash[:success] = "Password successfully saved."
      log_in @user
      redirect_to @user
    else
      render 'password_resets/edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # confirms a valid user
  def valid_user
    unless  @user && @user.activated? &&
            @user.authenticated?(:password_reset, params[:id])
      redirect_to root_url
    end
  end

  # checks expiration of reset token
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
