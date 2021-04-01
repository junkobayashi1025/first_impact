class AddColumnApprovalReports < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :approval, :boolean, default: false
  end

  def down
    remove_column :reports, :approval, :boolean, default: false
  end
end
