require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
    let!(:admin){ FactoryBot.create(:admin) }
    let!(:user1){ FactoryBot.create(:user1) }
    let!(:user2){ FactoryBot.create(:user2) }

    describe 'ユーザー登録機能' do
      context 'ユーザーを新規作成した場合' do
        it '作成したユーザーが表示される' do
          visit new_user_registration_path
          user = User.new(name: "name", email: "user@example.com", password: "password", password_confirmation: "password")
          fill_in 'user[name]', with: user.name
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          fill_in 'user[password_confirmation]', with: user.password_confirmation
          click_on 'create_new_account-submit'
          sleep(1)
          result = User.last
          expect(find_by_id("users-show-#{result.id}-name")).to have_content user.name
          expect(find_by_id("users-show-#{result.id}-email")).to have_content user.email
          end
        end
      context 'ログインしていない場合' do
        it 'ログインせず他の画面に飛ぼうとしたとき、ログイン画面に遷移する' do
         visit reports_path
         expect(current_path).to eq new_user_session_path
       end
      end
    describe 'ログインとログアウト' do
      context 'ログインした場合' do
        before do
          visit new_user_session_path
          fill_in 'user[email]', with: user1.email
          fill_in 'user[password]', with: user1.password
          click_on 'sign-in-submit'
          sleep(1)
        end
        it '自分の詳細画面に飛ぶ' do
          expect(find_by_id("users-show-#{user1.id}-name")).to have_content user1.name
          expect(find_by_id("users-show-#{user1.id}-email")).to have_content user1.email
        end
        it 'ユーザー一覧画面に自分の情報がある' do
          visit users_path
          expect(find_by_id("users-index__user-#{user1.id}-name")).to have_content user1.name
          expect(find_by_id("users-index__user-#{user1.id}-email")).to have_content user1.email
        end
        it 'ユーザが他人の編集画面に飛ぶと自分の詳細画面に遷移する' do
          visit edit_user_path(user2)
          expect(page).to have_content '権限がありません'
          expect(current_path).to eq user_path(user1)
        end
        it 'ログアウトできる' do
          click_on 'navbarDropdown-user'
          click_on 'header_nav_submit'
          sleep(1)
          expect(current_path).to eq unauthenticated_root_path
        end
      end
    end
    describe '管理者機能' do
      context '一般ユーザーの場合' do
        it '管理画面にアクセスできない' do
          visit new_user_session_path
          fill_in 'user[email]', with: user1.email
          fill_in 'user[password]', with: user1.password
          click_on 'sign-in-submit'
          sleep(1)
          visit rails_admin_path
        end
      end
      context '管理者の場合' do
        before do
          visit new_user_session_path
          fill_in 'user[email]', with: admin.email
          fill_in 'user[password]', with: admin.password
          click_on 'sign-in-submit'
          sleep(1)
        end
        it '管理画面にアクセスできる' do
          visit rails_admin_path
          expect(page).to have_content 'Report Share Admin'
        end
        it 'ユーザーの新規登録ができる' do
          visit rails_admin_path
          page.all('.pjax')[7].click
          click_on '新規作成'
          user = User.new(name: "name", email: "user@example.com", password: "password", password_confirmation: "password")
          fill_in "user[name]", with: user.name
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          fill_in 'user[password_confirmation]', with: user.password_confirmation
          click_on '保存'
          sleep(1)
          expect(page).to have_content user.name
          expect(page).to have_content user.email
        end
        it 'ユーザの編集画面からユーザを編集できる'do
          visit rails_admin_path
          page.all('.pjax')[7].click
          page.all('.edit_member_link')[0].click
          user = User.new(name: "name3", email: "user3@example.com", password: "password3", password_confirmation: "password3")
          fill_in 'user[name]', with: user.name
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          fill_in 'user[password_confirmation]', with: user.password_confirmation
          click_on '保存'
          sleep(1)
          expect(page).to have_content user.name
          expect(page).to have_content user.email
        end
        it 'ユーザーを削除できる'do
          visit rails_admin_path
          page.all('.pjax')[7].click
          page.all('.delete_member_link')[0].click
          click_on '実行する'
          expect(page).not_to have_content user2.email
          expect(page).to have_content user1.email
          expect(page).to have_content admin.email
        end
      end
    end
  end
end
