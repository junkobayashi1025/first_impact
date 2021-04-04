class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
   @users = User.all.order(created_at: :desc)
  end

  def show
    threshold = DateTime.now + 3.day
    @expired_reports = @user.reports.where('due <= ?', threshold).order(due: :asc)
    if @expired_reports.count > 0
      number = @expired_reports.count
      flash[:danger] = "期限切れ、期限直前のタスクが#{number}件あります。"
    end
  end
    # .or(@user.reports.where('confirmed_date <= ?', threshold).where(user_id: current_user.id, checkbox_interim: true, checkbox_final: false))

  def edit
  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to user_path
      flash[:success] = "ユーザー「#{@user.name}」を更新しました"
    else
      render 'edit'
    end
  end

  def destroy
     if @user.destroy
       redirect_to new_user_session_path
       flash[:danger] = "ユーザー「#{@user.name}」を削除しました"
     else
       redirect_to user_path(@user)
       flash[:danger] = "未完の報告書があるため、削除できません"
     end
   end

  private
  def set_user
   @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :icon)
  end
end
