class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.datetime :created_date
      t.string :owner
      t.string :author
      t.datetime :accrual_date, default: Date.current
      t.string :site_of_occurrence
      t.text :trouble_content
      t.text :first_aid
      t.text :interim_measures
      t.text :permanent_measures
      t.text :confirmation_of_effectiveness
      t.boolean :checkbox_first,   default: false
      t.boolean :checkbox_interim, default: false
      t.boolean :checkbox_final,   default: false
      t.references :user, foreign_key: { on_delete: :nullify }, index: true
      t.references :team, foreign_key: { on_delete: :nullify }, index: true
      t.timestamps
    end
  end
end
