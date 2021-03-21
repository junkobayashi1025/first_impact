class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name,                null: false, default: ""
      t.string :icon
      t.text :remark
      t.bigint :owner_id,            index: true, foreign_key: true
      t.bigint :charge_in_person_id, index: true, foreign_key: true
      t.references :user,            foreign_key: true
      t.timestamps
    end
  end
end
