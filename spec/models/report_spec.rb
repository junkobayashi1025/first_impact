require 'rails_helper'
RSpec.describe 'Reportモデル機能', type: :model do
  let(:user1){ FactoryBot.create(:user1) }
  let(:team){ FactoryBot.create(:team, owner_id: user1.id) }

  describe 'バリデーションのテスト' do
    context 'Reportのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        report = Report.new(title: '', user_id: user1.id, team_id: team.id,
                            accrual_date: Date.today, trouble_content: 'trouble_content',
                            first_aid: 'first_aid', interim_measures: 'interim_measures')
        expect(report).not_to be_valid
      end
    end
    context 'Reportのトラブル内容が空の場合' do
      it 'バリデーションにひっかる' do
        report = Report.new(trouble_content: '', title: 'report', user_id: user1.id,
                            team_id: team.id, accrual_date: Date.today,
                            first_aid: 'first_aid', interim_measures: 'interim_measures')
        expect(report).not_to be_valid
      end
    end
    context 'Reportの応急対応が空の場合' do
      it 'バリデーションにひっかる' do
        report = Report.new(first_aid: '', title: 'report', user_id: user1.id,
                            team_id: team.id, accrual_date: Date.today,
                            trouble_content: 'trouble_content', interim_measures: 'interim_measures')
        expect(report).not_to be_valid
      end
    end
    context 'Reportの暫定対策が空の場合' do
      it 'バリデーションにひっかる' do
        report = Report.new(interim_measures: '', title: 'report', user_id: user1.id,
                            team_id: team.id, accrual_date: Date.today,
                            trouble_content: 'trouble_content', first_aid: 'first_aid')
        expect(report).not_to be_valid
      end
    end
    context 'Reportの発生日が今日より後の場合' do
      it 'バリデーションにひっかる' do
        report = Report.new(interim_measures: 'report', title: 'report', user_id: user1.id,
                            team_id: team.id, accrual_date: Date.today + 1.days,
                            trouble_content: 'trouble_content', first_aid: 'first_aid')
        expect(report).not_to be_valid
      end
    end
    context 'Reportの必須事項が全て入力されている場合' do
      it 'バリデーションが通る' do
        report = Report.new(title: 'report', user_id: user1.id, team_id: team.id,
                            accrual_date: Date.today, trouble_content: 'trouble_content',
                            first_aid: 'first_aid', interim_measures: 'interim_measures')
        expect(team).to be_valid
      end
    end
  end
end
