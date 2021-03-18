class UsersController < ApplicationController
  def index
   @users = User.all.order(created_at: :desc)
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path, notice: I18n.t('views.messages.update_profile')
    else
      render 'edit'
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def destroy
   @user = current_user
     if @user.destroy
     redirect_to new_user_session_path
     flash[:danger] = "ユーザー「#{@user.name}」を削除しました"
     end
   end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:icon)
  end
end
