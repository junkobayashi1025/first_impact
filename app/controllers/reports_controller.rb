class ReportsController < ApplicationController
  # before_action :authenticate_user
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  def index
    @reports = Report.all.order(created_at: :desc)
  end

  def new
     @report = Report.new
     # @report.photos.build
  end

  def create
    @report = Report.new(report_params)
    binding.pry
      if @report.save
       redirect_to reports_path
       flash[:success] = '投稿が保存されました'
      else
       render 'new'
      end
  end

  def show
  end

  def edit
  end

  def update
   if params[:back]
     redirect_to report_path(@report)
   else
     if @report.update(report_params)
        flash[:notice] = "コメントを変更しました"
     else
        render :edit
        flash[:danger] = "コメントを変更できませんでした"
      end
        redirect_to report_path(@report)
     end
  end

  def destroy
    if @report.user == current_user
      if @report.destroy
        flash[:success] = '投稿が削除されました'
      end
    else
      flash[:danger] = '投稿の削除に失敗しました'
    end
    redirect_to reports_path(@report.user.id)
  end

  private
  def report_params
    params.require(:report).permit(:title, :created_at, :author, :accrual_date, :site_of_occurrence,
                                    :trouble_content, :first_aid, :interim_measures,
                                    :permanent_measures, :confirmation_of_effectiveness).merge(user_id: current_user.id)
  end

  def set_report
    @report = Report.find_by(id: params[:id])
  end
end
