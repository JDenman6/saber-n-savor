class UsersController < ApplicationController
  before_action :log_in_user,    only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_only,     only: [:destroy]

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      flash[:danger] = "UH-OH!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your account has been updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # Strong parameters
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    ### BEFORE FILTERS

    # Make sure users are logged in.
    def log_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirm the user is the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end

    # Make sure only admins can make protected actions.
    def admin_only
      redirect_to(root_url) unless current_user.admin?
    end
end
