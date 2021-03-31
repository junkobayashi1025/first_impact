class AssignsController < ApplicationController
  before_action :authenticate_user!
  before_action :email_exist?, only: [:create]
  before_action :user_exist?, only: [:create]

  def create
    team = Team.find(params[:team_id])
    user = email_reliable?(assign_params) ? User.find_or_create_by_email(assign_params) : nil
      if user
        team.invite_member(user)
        redirect_to team_url(team)
        flash[:success] = "ユーザー「#{user.name}」を招待しました"
      else
        redirect_to team_url(team)
        flash[:danger] = "招待に失敗しました"
      end
    end


    # user = User.find_or_create_by_email(assign_params)
    # team.invite_member(user)
    # redirect_to team_url(team), notice: "ユーザー「#{user.name}」を招待しました"
  # end

  def destroy
    assign = Assign.find(params[:id])
    assign.destroy
    redirect_to team_url(params[:team_id])
    flash[:success] = "ユーザー「#{assign.user.name}」を削除しました"
  end

  private
  def assign_params
    params[:email]
  end

  def email_exist?
    team = find_team(params[:team_id])
    if team.assign_users.exists?(email: params[:email])
      redirect_to team_url(team)
        flash[:danger] = "ユーザーは招待済みです"
    end
  end

  def email_reliable?(address)
    address.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end

  def user_exist?
    team = find_team(params[:team_id])
    unless User.exists?(email: params[:email])
      redirect_to team_url(team)
    end
  end

  def find_team(team_id)
   team = Team.find(params[:team_id])
 end
end
