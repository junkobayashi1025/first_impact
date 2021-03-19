class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

 def new
   @team = Team.new
 end

 def create
   @team = Team.new(teams_params)
   @team.user_id = current_user.id
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

 private

 def teams_params
   params.require(:team).permit(:name, :icon, :remark, :owner_id,
                                :charge_in_person_id, :user_id)
 end

 def set_team
   @team = Team.find_by(id: params[:id])
 end

end
