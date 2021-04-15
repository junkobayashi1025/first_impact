require 'rails_helper'
RSpec.describe '報告書管理機能', type: :system do
  let!(:admin){ FactoryBot.create(:admin) }
  let!(:user1){ FactoryBot.create(:user1) }
  let!(:user2){ FactoryBot.create(:user2) }
  let!(:team){ FactoryBot.create(:team, owner_id: admin.id) }
  let!(:assign){ FactoryBot.create(:assign, user_id: user1.id, team_id: team.id) }
  let!(:report){ FactoryBot.create(:report, team_id: team.id, user_id: user1.id) }
  let!(:comment){ FactoryBot.create(:comment, report_id: report.id, user_id: user1.id) }
  let!(:attachment){ FactoryBot.create(:attachment, report_id: report.id) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user1.email
    fill_in 'user[password]', with: user1.password
    click_on 'sign-in-submit'
  end

  describe '報告書作成機能' do
    context '報告書を新規作成した場合' do
      before do
        visit team_path(team)
        click_on 'new_report-submit'
        report = Report.new(title: "report", accrual_date: Date.current,
                             trouble_content: "trouble_content", first_aid: "first_aid",
                             interim_measures: "interim_measures")
        fill_in 'report[title]',            with: report.title
        fill_in 'report[accrual_date]',     with: report.accrual_date
        fill_in 'report[trouble_content]',  with: report.trouble_content
        fill_in 'report[first_aid]',        with: report.first_aid
        fill_in 'report[interim_measures]', with: report.interim_measures
        click_on 'create_report_submit'
      end
      it '所属するチームに報告書が表示される' do
      expect(page).to have_content report.title
      end
      it '報告書一覧ページに表示される' do
      visit reports_path
      expect(page).to have_content report.title
      end
    end
  end
  describe '報告書の編集＆削除' do
    context 'ユーザーが報告書の作成者の場合' do
      it '報告書を編集できる' do
       visit edit_report_path(report.id)
       report = Report.new(title: "report1", accrual_date: Date.current + 30.days,
                            trouble_content: "trouble_content1", first_aid: "first_aid1",
                            interim_measures: "interim_measures1")
       fill_in 'report[title]',            with: report.title
       fill_in 'report[accrual_date]',     with: report.accrual_date
       fill_in 'report[trouble_content]',  with: report.trouble_content
       fill_in 'report[first_aid]',        with: report.first_aid
       fill_in 'report[interim_measures]', with: report.interim_measures
       click_on '変更'
       expect(page).to have_content '報告書を更新しました'
      end
      it '報告書を削除できる' do
       visit report_path(report.id)
       click_on "report_show_delete-#{report.id}-submit"
       page.driver.browser.switch_to.alert.accept
       sleep(1)
       expect(page).to have_content "報告書「#{report.title}」が削除されました"
      end
    end
  end
  describe '報告書の詳細' do
    context '報告書一覧ページにて報告書のタイトルをクリックした場合' do
      it 'クリックした報告書の詳細ページに遷移する' do
        visit reports_path
        result = Report.last
        click_on "reports-index__report-#{result.id}-title"
        expect(page).to have_content result.title
      end
    end
  end
  describe '報告書のへのコメント' do
    context 'チームに所属しているメンバーの場合' do
      it 'チーム内の報告書にコメントできる' do
        visit report_path(report.id)
        comment = Comment.new(comment: "comment")
        fill_in 'comment[comment]', with: comment.comment
        click_on "コメント投稿"
        expect(page).to have_content comment.comment
      end
      # it '自分がコメントしたものを編集できる' do
      #   visit report_path(report.id)
      #   click_on "comments-index__comment-#{comment.id}-edit_comment"
      #   comment1 = Comment.new(comment: "comment編集")
      #   fill_in 'comment[comment]', with: comment1.comment
      #   click_on "comments__edit-submit"
      #   expect(page).to have_content comment.comment
      end
      it '自分がコメントしたものを削除できる' do
        visit report_path(report.id)
        click_on "comments-index__comment-#{comment.id}-delete_comment"
        expect(page).not_to have_content comment.comment
      end
    end
    context 'チームに所属していないメンバーの場合' do
      it 'チーム内の報告書にコメントできない' do
        click_on 'navbarDropdown-user'
        click_on 'header_nav_submit'
        sleep(1)
        visit new_user_session_path
        fill_in 'user[email]', with: user2.email
        fill_in 'user[password]', with: user2.password
        click_on 'sign-in-submit'
        sleep(1)
        visit report_path(report.id)
        comment = Comment.new(comment: "comment")
        fill_in 'comment[comment]', with: comment.comment
        click_on "コメント投稿"
        expect(page).to have_content "権限がありません"
      end
    end
  end
  describe '報告書への資料添付' do
    it '報告書に画像を添付する' do
      visit edit_report_path(report.id)
      attach_file 'report[attachments_attributes][1][image]', "#{Rails.root}/spec/files/icon2.jpg"
      click_on "変更"
    end
    it '報告書に添付した画像を削除する' do
      visit report_path(report.id)
      click_on "reports-show__report-#{attachment.id}-delete_icon"
    end
  end
  describe '報告書の絞込み(ソート)' do
    it '報告書一覧ページにてタイトル検索する' do
      visit team_path(team)
      click_on 'new_report-submit'
      report1 = Report.new(title: "検索テスト", accrual_date: Date.current,
                           trouble_content: "trouble_content", first_aid: "first_aid",
                           interim_measures: "interim_measures")
      fill_in 'report[title]',            with: report1.title
      fill_in 'report[accrual_date]',     with: report1.accrual_date
      fill_in 'report[trouble_content]',  with: report1.trouble_content
      fill_in 'report[first_aid]',        with: report1.first_aid
      fill_in 'report[interim_measures]', with: report1.interim_measures
      click_on 'create_report_submit'
      sleep(1)
      visit reports_path
      fill_in 'q[title_cont]', with: '検索テスト'
      click_on '検索'
      sleep(1)
      expect(page).to have_content report1.title
    end
  end
end
