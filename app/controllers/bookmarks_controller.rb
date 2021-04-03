class BookmarksController < ApplicationController
  # before_action :authenticate_user
  before_action :report_params, only: [:create, :destroy]

  # def show
  #   @bookmark = current_user.bookmarks.build(bookmark_params)
  #     # binding.pry
  #   @report = @bookmark.post
  #
  #   if @bookmark.save
  #     respond_to :js
  #   end
  # end

  def create
    if current_user != @report.user && current_user != @report.team.owner
      Bookmark.create(user_id: current_user.id, report_id: params[:id])
    else
      redirect_to report_path(@report), notice:"権限がありません"
    end
    # if @bookmark.save
    #   respond_to :js
    # end
  end

  def destroy
    Bookmark.find_by(user_id: current_user.id, report_id: params[:id]).destroy
    # if @bookmark.destroy
    #   respond_to :js
    # end
  end

  # def destroy
  #   @bookmark = Bookmark.find(params[:id])
  #   @report = @bookmark.post

  # end

  private
  def report_params
    @report = Report.find(params[:id])
  end
end
