class AssignsController < ApplicationController
  before_action :authenticate_user!

  def create
    team = Team.find(params[:team_id])
    user = User.find_or_create_by_email(assign_params)
    team.invite_member(user)
    redirect_to team_url(team), notice: "ユーザー「#{user.name}」を招待しました"
  end

  def destroy
    assign = Assign.find(params[:id])
      # if assign.team.owner == current_user && assign.team.charge_in_person.nil?
      assign.destroy
      redirect_to team_url(params[:team_id])
      flash[:success] = "ユーザー「#{assign.user.name}」を削除しました"
      else
      redirect_to team_url(params[:team_id])
      flash[:danger] = "担当者権限を有するため削除できません"
      end
  end

  private

  def assign_params
    params[:email]
  end
end
