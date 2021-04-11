class CommentsController < ApplicationController

  def create
    @report = Report.find(params[:report_id])
    if current_user.assigns.ids.include?(@report.team.id)
      @comment = @report.comments.build(comment_params)
      @comment.user_id = current_user.id
      @comment.save
      render :index
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
 def comment_params
   params.require(:comment).permit(:comment, :report_id, :user_id)
 end
end
