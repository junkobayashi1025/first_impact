class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index]
  before_action :authenticate_user!

  def current_user_home
    redirect_to current_user
  end

  def index
   # @users = User.all.order(created_at: :desc)
   @users = @q.result(distinct: true).order(created_at: :desc)
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
    if @user.id == current_user.id
    else
      redirect_to user_path(@user)
      flash[:notice] = "権限がありません"
    end
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
    undone_reports = @user.reports.where(checkbox_final: false)
    if @user.id == current_user.id
      @user.destroy_step
    else
      redirect_to user_path(@user)
      flash[:notice] = "権限がありません"
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

  def set_q
    @q = User.ransack(params[:q])
  end

  def current_user?


  end
end
