require 'rails_helper'
RSpec.describe 'チーム管理機能', type: :system do
  before do
    admin_user = FactoryBot.create(:admin)
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_on 'sign-in-submit'
    FactoryBot.create(:task, user: admin_user)
    FactoryBot.create(:new_task, user: admin_user)
  end
  describe 'タスク管理機能', type: :system do
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索キーワードを含むタスクで絞りこまれる" do
          visit tasks_path
          fill_in 'title', with: 'ta'
          click_on '検索'
          expect(page).to have_content 'task'
        end
      end
      context 'ステータス検索をした場合' do
        it "ステータスに完全一致するタスクが絞り込まれる" do
          visit tasks_path
          select 'New', from: 'status'
          click_on '検索'
          sleep(1)
          expect(page).to have_content 'New'
        end
      end
      context 'タイトルのあいまい検索とステータス検索をした場合' do
        it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
          visit tasks_path
          fill_in 'title', with: 'ta'
          select 'New', from: 'status'
          click_on '検索'
          sleep(1)
          expect(page).to have_content 'task'
          expect(page).to have_content 'New'
        end
      end
    end
  end
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
      visit new_task_path
      task = Task.new(title: "test", content: "content", deadline: Time.current + 7.days, status: 'New', priority: 'low')
      fill_in 'task[title]', with: task.title
      fill_in 'task[content]', with: task.content
      fill_in 'task[deadline]', with: task.deadline
      select task.status, from: 'task[status]'
      select task.priority, from: 'task[priority]'
      click_on 'task_form_submit'
      sleep(1)
      result = Task.last
      expect(find_by_id("tasks-index__task-#{result.id}-title")).to have_content task.title
      expect(find_by_id("tasks-index__task-#{result.id}-content")).to have_content task.content
      expect(find_by_id("tasks-index__task-#{result.id}-status")).to have_content task.status
      expect(find_by_id("tasks-index__task-#{result.id}-priority")).to have_content task.priority
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
       visit tasks_path
       expect(page).to have_content 'new_task'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'task'
      end
    end
    context '終了期限でソートした場合' do
      it 'タスクが終了期限順に並んでいる' do
        visit tasks_path
        click_on '終了期限'
        sleep(1)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'task'
        expect(task_list[1]).to have_content 'new_task'
      end
    end
    context '優先順位が高い順でソートした場合' do
      it 'タスクが優先順が高い順に並んでいる' do
        visit tasks_path
        click_on '優先度'
        sleep(1)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'high'
        expect(task_list[1]).to have_content 'low'
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
         visit task_path(1)
         expect(page).to have_content 'task'
         visit task_path(2)
         expect(page).to have_content 'new_task'
       end
     end
  end
end
