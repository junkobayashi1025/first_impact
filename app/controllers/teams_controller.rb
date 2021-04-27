class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :calendar]
  before_action :set_q, only: [:index]
  before_action :authenticate_user!
  before_action :reject_unless_owner, only: %i[edit update destroy]

 def index
   @teams = @q.result(distinct: true).page(params[:page]).per(8)
 end

 def new
   @team = Team.new
 end

 def create
   @team = current_user.teams.new(teams_params)
   # @team = Team.new(teams_params)
   # @team.owner_id = current_user.id
   if @team.save
     @team.invite_member(@team.owner)
     redirect_to team_path(@team), notice: "チーム「#{@team.name}」を作成しました"
     # flash[:notice] = "チーム「#{@team.name}」を作成しました"
   else
     render 'new'
   end
 end

 def show
   @expired_reports = current_user.assign_teams.reports.deadline_approaching.order(due: :asc)
 end

 def edit
 end

 def update
   if params[:back]
     redirect_to team_path(@team)
   else
     if @team.update(teams_params)
       redirect_to team_path(@team)
       flash[:success] = "チーム「#{@team.name}」を編集しました"
     else
       render 'edit'
     end
   end
 end

 def destroy
   undone_reports = @team.reports.where(checkbox_final: false)
   if undone_reports.count > 0
     redirect_to team_path(@team)
     flash[:danger] = "未完の報告書がある為、チームを解散できません"
   else
     @team.destroy
     redirect_to current_user
     flash[:danger] = "チーム「#{@team.name}」を解散しました"
   end
 end

 def change_owner
   @team = Team.find(params[:id])
   @user = User.find(params[:user_id])
   @team.update(owner_id: params[:user_id])
   redirect_to @team
 end

 def calendar
   if params[:back]
     redirect_to team_path(@team)
   else
    @reports = Report.where(team_id: @team.id, checkbox_final: false)
   end
 end

 private

 def teams_params
   params.require(:team).permit(:name, :icon, :remark, :owner_id)
 end

 def set_team
   @team = Team.find_by(id: params[:id])
 end

 def set_q
   @q = Team.ransack(params[:q])
 end

  def reject_unless_owner
    if @team.owner != current_user
      redirect_to @team, notice:"権限がありません"
    end
  end

end
