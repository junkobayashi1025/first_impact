require 'rails_helper'
RSpec.describe 'チーム管理機能', type: :system do
  let!(:admin){ FactoryBot.create(:admin) }
  let!(:user1){ FactoryBot.create(:user1) }
  let!(:user2){ FactoryBot.create(:user2) }
  let!(:team){ FactoryBot.create(:team, owner_id: admin.id) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_on 'sign-in-submit'
  end
  describe 'チーム作成機能' do
    context 'チームを新規作成した場合' do
      it 'チーム詳細が表示される＆ユーザーが作成したチームの責任者になる' do
      click_on 'new-team-submit'
      team = Team.new(name: "admin", remark: "admin", owner_id: admin.id)
      fill_in 'team[name]', with: team.name
      fill_in 'team[remark]', with: team.remark
      click_on 'create_team_submit'
      sleep(1)
      result = Team.last
      expect(find_by_id("teams-show__team-#{result.id}-name")).to have_content team.name
      expect(find_by_id("teams-show__team-#{result.id}-owner_name")).to have_content team.owner.name
      expect(find_by_id("teams-show__team-#{result.id}-remark")).to have_content team.remark
      end
    end
  end
  describe '一覧表示機能' do
    context 'チーム一覧画面に遷移した場合' do
      it '作成済みのチーム一覧が表示される' do
       visit teams_path
       expect(page).to have_content 'team'
      end
    end
  end
  describe 'チーム編成機能' do
    before do
      click_on 'new-team-submit'
      team = Team.new(name: "admin", remark: "admin", owner_id: admin.id)
      fill_in 'team[name]', with: team.name
      fill_in 'team[remark]', with: team.remark
      click_on 'create_team_submit'
      sleep(1)
      fill_in 'email', with: user2.email
      click_on 'invite_member_submit'
    end
    context 'チームに既存するユーザーを招待した場合' do
      it 'チームのメンバーになる' do
        fill_in 'email', with: user1.email
        click_on 'invite_member_submit'
        sleep(1)
        expect(find_by_id("teams-show__user-#{user1.id}-member_name")).to have_content user1.name
      end
    end
    context 'チームに既存しないのユーザーを招待した場合' do
      it 'チームに招待できない' do
        fill_in 'email', with: 'no_account_user.@example.com'
        click_on 'invite_member_submit'
        sleep(1)
        expect(page).to have_content 'ユーザーは存在しません'
      end
    end
    context 'チームにすでに招待ずみのメンバーを招待した場合' do
      it 'チームに招待できない' do
        fill_in 'email', with: user2.email
        click_on 'invite_member_submit'
        sleep(1)
        expect(page).to have_content 'ユーザーは招待済みです'
      end
    end
    context 'チームに所属するメンバーの離脱ボタンを押した場合' do
      it 'そのメンバーはチームから離脱する' do
        click_on "team_show_dropout_team-#{user2.id}-submit"
        expect(page).to have_content "ユーザー「#{user2.name}」を削除しました"
      end
    end
    context '責任権限を他のチームメンバーに移動した場合' do
      it '指名されたメンバーが責任者になる' do
        click_on "team_show_owner_change-#{user2.id}-submit"
        # expect(team.owner.name).to have_content user2.name
      end
    end
  end
end
