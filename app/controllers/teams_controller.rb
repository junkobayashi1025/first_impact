class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

 def new
   @team = Team.new
 end

 def create
   @team = Team.new(teams_params)
   @team.owner_id = current_user.id
   if @team.save
     redirect_to team_path(@team), notice: 'グループを作成しました。'
   else
     render 'new'
   end
 end

 def index
   @teams = Team.all
 end

 def show
 end

 def edit
 end

 def change_owner
      @team = Team.find(params[:id])
      @user = User.find(params[:user_id])
      @team.update(owner_id: params[:user_id])
      redirect_to @team
  end

 private

 def teams_params
   params.require(:team).permit(:name, :icon, :remark, :owner_id)
 end

 def set_team
   @team = Team.find_by(id: params[:id])
 end

end
