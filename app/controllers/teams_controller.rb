class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = Team.all
  end

 def new
   @team = Team.new
 end

 def create
   @team = Team.new(teams_params)
   @team.owner_id = current_user.id
   @team.charge_in_person_id = current_user.id
   if @team.save
     redirect_to team_path(@team)
     flash[:notice] = "チーム「#{@team.name}」を作成しました"
   else
     render 'new'
   end
 end

 def show
 end

 def edit
 end

 def update
   if @team.update(teams_params)
     redirect_to team_path(@team)
     flash[:success] = "チーム「#{@team.name}」を編集しました"
   else
     render 'edit'
   end
 end

 def destroy
    @team.destroy
    redirect_to teams_path
    flash[:danger] = "チーム「#{@team.name}」を解散しました"
  end

 def change_owner
      @team = Team.find(params[:id])
      @user = User.find(params[:user_id])
      @team.update(owner_id: params[:user_id])
      redirect_to @team
  end

  def charge_in_person
       @team = Team.find(params[:id])
       @user = User.find(params[:user_id])
       @team.update(charge_in_person_id: params[:user_id])
       redirect_to @team
   end

 private

 def teams_params
   params.require(:team).permit(:name, :icon, :remark, :owner_id, :charge_in_person_id)
 end

 def set_team
   @team = Team.find_by(id: params[:id])
 end

end
