class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :approval_request, :approval, :reject]
  before_action :set_q, only: [:index]
  before_action :set_q_archive, only: [:archive]
  before_action :authenticate_user!

  def index
    if params[:tag_name]
      @results = Report.where(checkbox_final: false).tagged_with("#{params[:tag_name]}").page(params[:page]).per(8)
    else
      # puts params[:q]
      # puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@s"
      @results = params[:q] ? @q.result : Report.where(checkbox_final: false).order(created_date: :desc).page(params[:page]).per(8)
    end

    # binding.pry
    # @results = Report.all
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

  def archive
    if params[:tag_name]
      @archives = Report.where(checkbox_final: true).tagged_with("#{params[:tag_name]}").page(params[:page]).per(8)
    else
      @archives = params[:q] ? @q.result : Report.where(checkbox_final: true).order(created_date: :desc).page(params[:page]).per(8)
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
    if current_user == @report.team.owner || current_user == @report.user && @report.approval == false
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
     else
        render :edit
        flash[:danger] = "報告書を変更できませんでした"
      end
        redirect_to report_path(@report)
     end
  end

  def destroy
    if current_user == @report.user || current_user == @report.team.owner
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
    # case params[:q][:search_item]
    # when 1 return  @colomn = title
    # when 2 return  @colomn = team_name
    # when 3 return  @colomn = team_owner_name
    # when 4 return  @colomn = author
    # end
    @q = Report.where.not(checkbox_final: true).ransack(params[:q])
    #飛んできたパラメータを受取る⇒変数化して、検索させたいカラムと検索ワードに分ける
    #{
    #  @colomn = team_owner_name
    #  @keyword = admin
    #}
    #⇒
    #ランサックのパラメーターに該当するカラムのところに検索ワードを入れる

    # @ransack_q = @colom + "_cont"

    # {
    #    q = {"#{@ransack_q}"=>"admin"}
    # }


    # {"title_cont"=>"", "team_name_cont"=>"", "team_owner_name_cont"=>"", "author_cont"=>"", "step_cont"=>"", "status_cont"=>""}
    # @q = Report.ransack(q)
    # @q = Report.where(user_id: current_user.id).ransack(params[:q])
  end

  def set_q_archive
    @q = Report.where(checkbox_final: true).ransack(params[:q])
    # @q = Report.where(user_id: current_user.id).ransack(params[:q])
  end
end
