class ReportsController < ApplicationController
  # before_action :authenticate_user
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index]

  def index
    @results = params[:q] ? @q.result : Report.order(created_date: :desc)
    # binding.pry
    # @results_confirmed = @results.where.not(confirmed_date:nil)
    # @results_confirmed.each do |result_confirmed|
    #   result_confirmed = result_confirmed.accrual_date.update(confirmed_date)
    # end
    # if @results.confirmed_date.present?
    #
    #   @results.accrual_date.update(@results.confirmed_date)
    # end

  end

  def new
    @report = Report.new
    @report.author = current_user.name
    @team = Team.find(params[:team_id])
     # @report.photos.build
  end

  def create
    # binding.pry
    @team = Team.find(params[:report][:team_id])
    @report = Report.new(report_params)
    @report.team_id = @team.id
    # @report = @team.reports.build(report_params)
    # binding.pry
    # @report = Report.new(report_params)
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

  # def search
  #   @results = @q.result.order(created_date: :desc)
  # end

  private
  def report_params
    params.require(:report).permit(:title, :created_date, :confirmed_date, :author, :accrual_date, :site_of_occurrence,
                                    :trouble_content, :first_aid, :interim_measures, :search_item,
                                    :permanent_measures, :confirmation_of_effectiveness, :checkbox_first, :checkbox_interim, :checkbox_final, :team_id).merge(user_id: current_user.id)
  end

  def set_report
    @report = Report.find_by(id: params[:id])
  end

  def set_q
    @q = Report.ransack(params[:q])
    # @q = Report.where(user_id: current_user.id).ransack(params[:q])
  end
end
