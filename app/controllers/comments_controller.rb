class CommentsController < ApplicationController
  before_action :which_report, only: [:create, :edit, :update]

  def create
    if current_user.assign_teams.ids.include?(@report.team.id)
      @comment = @report.comments.build(comment_params)
      @comment.user_id = current_user.id
      @comment.save
      render :index
    else
      redirect_to report_path(@report), notice:"権限がありません"
    end
  end

  def edit
    if current_user.assign_teams.ids.include?(@report.team.id)
      @comment = @report.comments.find(params[:id])
    else
      redirect_to report_path(@report), notice:"権限がありません"
    end
  end

  def update
    if current_user.assign_teams.ids.include?(@report.team.id)
      @comment = @report.comments.find(params[:id])
      @comment.update(comment_params)
    else
      redirect_to report_path(@report), notice:"権限がありません"
    end
  end

 def destroy
   @comment = Comment.find(params[:id])
   if @comment.destroy
     render :index
   end
 end

 private
 def set_comment
   @comment = Comment.find(params[:id])
 end

 def which_report
   @report = Report.find(params[:report_id])
 end

 def comment_params
   params.require(:comment).permit(:comment, :report_id, :user_id)
 end
end
