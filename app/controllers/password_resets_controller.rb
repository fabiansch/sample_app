class PasswordResetsController < ApplicationController
  def new
  end

  def edit
    user = User.find_by(email: params[:email])
    if user &&
       user.authenticated?(:password_reset, params[:id]) &&
       user.activated?

    else
      flash[:danger] = "Invalid password reset token."
      redirect_to root_url
    end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.password_reset
      @user.send_password_reset_email
      flash[:info] = "Password instructions sent to your email address."
      redirect_to root_url
    else
      flash.now[:danger] = "Given email is not known."
      render 'password_resets/new'
    end
  end

  def update
    @user = User.find_by(email: params[:password_reset][:email])
    token = params[:password_reset][:password_reset_token]

    if @user && @user.authenticated?(:password_reset, token)
      password = params[:password_reset][:password]
      password_confirmation = params[:password_reset][:password_confirmation]

      if @user.update_attributes({ password: password,
                                  password_confirmation: password_confirmation})
        flash[:success] = "Changes successfully saved."
        log_in @user
        redirect_to @user
      else
        flash.now[:danger] = "Uuuups.."
        render 'password_resets/edit'
      end
    end


  end
end
