class AddColumnStep < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :step,   :string
    add_column :reports, :status, :string
  end

  def down
    remove_column :reports, :step,   :string
    remove_column :reports, :status, :string
  end
end
