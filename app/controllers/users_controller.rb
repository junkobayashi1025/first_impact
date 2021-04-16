class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index]
  before_action :authenticate_user!

  def current_user_home
    redirect_to current_user
  end

  def index
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    threshold = DateTime.now + 3.day
    @expired_reports = @user.reports.where('due <= ?', threshold).order(due: :asc)
    if @expired_reports.count > 0
      number = @expired_reports.count
      flash[:danger] = "期限切れ、期限直前のタスクが#{number}件あります。"
    end
  end

  def edit
    if @user.id == current_user.id
    else
      redirect_to user_path(current_user)
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
      if @user.assigns.empty? && undone_reports.count == 0
        @user.destroy
        redirect_to new_user_session_path
        flash[:success] = "ユーザー「#{@user.name}」を削除しました"
      elsif undone_reports.count > 0
        redirect_to user_path(@user)
        flash[:danger] = "未完の報告書がある為、削除できません"
      else
        redirect_to user_path(@user)
        flash[:danger] = "チームに所属している為、削除できません"
      end
    else
      redirect_to user_path(@user)
      flash[:notice] = "権限がありません"
    end
  end

  def calendar
    @author_reports = Report.where(user_id: current_user.id, checkbox_final: false).order(created_at: :desc)
    @team_owner_reports = Report.where(user_id: current_user.id, checkbox_final: false).order(created_at: :desc)
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

end
