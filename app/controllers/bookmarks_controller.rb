class BookmarksController < ApplicationController
  before_action :report_params, only: [:create, :destroy]

  def create
    if current_user != @report.team.owner && current_user != @report.user
      Bookmark.create(user_id: current_user.id, report_id: params[:id])
    else
      redirect_to reports_path, notice:"権限がありません"
    end
  end

  def destroy
    if current_user != @report.team.owner && current_user != @report.user
      Bookmark.find_by(user_id: current_user.id, report_id: params[:id]).destroy
    else
      redirect_to reports_path, notice:"権限がありません"
    end
  end

  private
  def report_params
    @report = Report.find(params[:id])
  end
end
