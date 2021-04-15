class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :approval_request, :approval, :reject]
  before_action :set_q, only: [:index]
  before_action :set_q_archive, only: [:archive]
  before_action :authenticate_user!

  def index
    if params[:tag_name]
      @results = Report.where(checkbox_final: false).tagged_with("#{params[:tag_name]}").page(params[:page]).per(8)
    else
      @results = params[:q] ? @q.result.page(params[:page]).per(8) : Report.where(checkbox_final: false).order(created_date: :desc).page(params[:page]).per(8)
    end
  end

  def archive
    if params[:tag_name]
      @archives = Report.where(checkbox_final: true).tagged_with("#{params[:tag_name]}").page(params[:page]).per(8)
    else
      @archives = params[:q] ? @q.result.page(params[:page]).per(8) : Report.where(checkbox_final: true).order(created_date: :desc).page(params[:page]).per(8)
    end
  end

  def new
    @report = Report.new
    @report.author = current_user.name
    5.times { @report.attachments.build }
    @team = Team.find(params[:team_id])
  end

  def create
    @team = Team.find(params[:report][:team_id])
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.step_string
    @report.status_string
    if @report.save
      redirect_to team_path(@report.team)
      flash[:success] = "報告書「#{@report.title}」が保存されました"
      CreateReportMailer.create_report_mailer(@team, @report).deliver
    else
      render 'new'
    end
  end

  def show
    @comment = Comment.new
    @comments = @report.comments
  end

  def edit
    if @report.checkbox_final == false && current_user == @report.team.owner || current_user == @report.user && @report.approval == false
      @report.build_attachment_for_form
    else
      redirect_to report_path(@report)
      flash[:notice] = '承認依頼中のため編集できません'
    end
  end

  def update
    if params[:back]
      redirect_to report_path(@report)
    else
      if @report.update(report_params)
        @report.step_string
        flash[:notice] = "報告書を更新しました"
        UpdateReportMailer.update_report_mailer(@report).deliver
        redirect_to report_path(@report)
      else
        render :edit
       end
     end
   end

  def destroy
    if current_user == @report.user || current_user == @report.team.owner && @report.checkbox_final == false
      if @report.destroy
        flash[:success] = "報告書「#{@report.title}」が削除されました"
      end
    else
      flash[:danger] = '報告書の削除に失敗しました'
    end
    redirect_to reports_path(@report.user.id)
  end

  def approval_request
    if current_user == @report.user
      @report.update(approval: true)
      @report.status_string
      redirect_to report_path(@report)
      flash[:notice] = "承認依頼をしました"
      ApprovalRequestMailer.approval_request_mailer(@report).deliver
    end
  end

  def approval
    if current_user == @report.team.owner
      @report.update(approval: false)
      @report.status_string
      redirect_to report_path(@report)
      flash[:notice] = "承認しました"
      ApprovalMailer.approval_mailer(@report).deliver
    end
  end

  def reject
    if current_user == @report.team.owner
      @report.update(approval: false)
      @report.status_string
      redirect_to report_path(@report)
      flash[:notice] = "拒否しました"
      RejectMailer.reject_mailer(@report).deliver
    end
  end

  private
  def report_params
    params.require(:report).permit(
      :title,
      :created_date,
      :confirmed_date,
      :author,
      :accrual_date,
      :site_of_occurrence,
      :trouble_content, :first_aid,
      :interim_measures,
      :search_item,
      :permanent_measures,
      :confirmation_of_effectiveness,
      :checkbox_first,
      :checkbox_interim,
      :checkbox_final,
      :team_id,
      :tag_list,
      :approval,
      :step,
      :status,
      :due,
      attachments_attributes: [
        :image
      ]
    )
  end

  def set_report
    @report = Report.find(params[:id])
  end

  def set_q
    @q = Report.where.not(checkbox_final: true).ransack(params[:q])
  end

  def set_q_archive
    @q = Report.where(checkbox_final: true).ransack(params[:q])
  end
end
