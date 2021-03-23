class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.datetime :created_date
      t.string :author
      t.datetime :accrual_date
      t.string :site_of_occurrence
      t.text :trouble_content
      t.text :first_aid
      t.text :interim_measures
      t.text :permanent_measures
      t.text :confirmation_of_effectiveness
      t.boolean :checkbox_first
      t.boolean :checkbox_interim
      t.boolean :checkbox_final
      t.references :user, foreign_key: true, index: true, null: false
      t.references :team, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
